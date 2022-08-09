# seccamp2022 Blue/Green Switcher デザイン
## 独立した三角形の BB が二面あるトポロジー
![topo](./topo.svg)

- Blue で 3 つ，Green で 3 つ
- Blue/Gree は接続しないでそれぞれ独立した三角形を作る
- 三角形のそれぞれの頂点は EX につながる
- 想像以上に複雑なトポロジーになってしまったので，BGP unnum を利用する
- 趣味により，IPv6 Single Stack AS です

## BGP Confederation を使う
- Blue/Green，EX は BGP Confederation を利用して，外部から見ると AS 65000 として振る舞う
- AS 65100/65200/65300 は EX を通して AS 65000 とピアを張る

## Blue/Green の切り替え
- MED 値を利用して切り替える
- SDN Controller が Blue/Green のルータに対して MED の切り替えを行う
- EX，CE は Blue/Green のバックボーンルータ群の MED を尊重するコンフィグを行う

## 戦略
- トポロジーの作成は tinet で行う
    - 先述の通り，基本は BGP Unnumered を利用する
    - アドレス割当，広告するネットワークについては後述
- SDN Controller は k8s の CRD を利用して作成する
    - KloudNFV
- 動作させる環境
    - kind で k8s の環境を作成する
    - ちゃんとやるなら...
        - 各ルータとホストネットワークをつなぐブリッジ (マネージメントネットワーク) を作成
        - それを介して kind と通信
        - IPv6 Only
        - 今回はそのあたりのかっこよさは妥協
    - 本来分散コントローラは本来文字通り NFV が載る VM ごとに分散させて運用だけど...
        - tinet で構築するため，全て開発環境ホスト上でそのまま動作
        - docker in docker を利用して，所属しているルータにだけ設定を入れるようにする
            - Blue-A 用のコントローラは Blue-A しかコントロールしない


## ステークホルダー
- それぞれのノードの所有権
  - Customer
    - CM-{A/B/C}
  - Provider
    - BB/EX/PE
  - 外部AS 
    - EA-{A/B/C}

## n% deploy
- データモデル
```yaml
apiVersion: seccamp.sabaniki.vsix.wide.ad.jp/v1
kind: BgSwitcherGroup
metadata:
  name: bgswitchergroup-sample
spec:
  groups:
    - color: blue
      weight: 10
    - color: green
      weight: 90
  routers:
    - router:
      name: EX-A
      peer-to:
        - Blue-A
        - Green-A
    - router:
      name: EX-B
      peer-to:
        - Blue-B
        - Green-B
    - router:
      name: EX-C
      peer-to:
        - Blue-C
        - Green-C
    - router:
      name: PE-A
      peer-to:
        - Blue-A
        - Green-A
    - router:
      name: PE-B
      peer-to:
        - Blue-B
        - Green-B
    - router:
      name: PE-C
      peer-to:
        - Blue-C
        - Green-C

status:
  groups:
    - color: blue
      weight: 10
    - color: green
      weight: 90
  routers:
    - router:
      name: PE-A
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
    - router:
      name: PE-B
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
    - router:
      name: PE-C
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
    - router:
      name: EX-A
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
    - router:
      name: EX-B
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
    - router:
      name: EX-C
      created: true
      groups:
        - color: blue
          weight: 10
        - color: green
          weight: 90
```

```yaml
apiVersion: seccamp.sabaniki.vsix.wide.ad.jp/v1
kind: BgSwitcher
metadata:
  name: EX-A
spec:
  groups:
    - color: blue
      weight: 10
    - color: green
      weight: 90
  peers:
    - name: Blue-A
      color: blue
    - name: Green-A
      color: green

  status:
  groups:
    - color: blue
      weight: 10
    - color: green
      weight: 90
  peer-to:
    - name: Blue-A
      color: blue
    - name: Green-A
      color: green
```
- weight を指定するとそれに応じた割合で首を振る
  - 外から内側へ始めた通信は

- extcommunity bandwidth を利用する
  - 今までとは逆に行う
    - EX-{A/B/C}，PE-{A/B/C} に分散コントローラを設置する
      - EX ... 外向きの通信，トランジット通信を曲げる
      - PE ... AS の中の顧客の通信を曲げる
    - その分散コントローラが自分自身の `route-map WIEGHT_BLUE permit 5` 及び `route-map WIEGHT_GREEN permit 10` を編集する
  - BB に現在 MED の設定をしている route-map は削除する


### 以下 config サンプル
```
❯ dexec vtysh -c "show running-con"
docker exec -it Blue-A vtysh -c show running-con

Building configuration...

Current configuration:
!
frr version 8.3-dev-my-manual-build
frr defaults traditional
hostname Blue-A
service integrated-vtysh-config
!
interface lo
 ipv6 address 2001:db8:6500:100:ace::1/128
exit
!
router bgp 64600
 bgp router-id 10.64.60.1
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp confederation identifier 65000
 bgp confederation peers 64501 64502 64503 64601
 neighbor BB-BLUE peer-group
 neighbor BB-BLUE remote-as 64600
 neighbor CONSUMERS peer-group
 neighbor EX-A peer-group
 neighbor EX-A remote-as 64501
 neighbor blue-b interface peer-group BB-BLUE
 no neighbor blue-b capability extended-nexthop
 neighbor blue-c interface peer-group BB-BLUE
 no neighbor blue-c capability extended-nexthop
 neighbor pe-a interface peer-group CONSUMERS
 neighbor pe-a remote-as 64701
 no neighbor pe-a capability extended-nexthop
 neighbor ex-a interface peer-group EX-A
 no neighbor ex-a capability extended-nexthop
 !
 address-family ipv6 unicast
  network 2001:db8:6500::/48
  network 2001:db8:6500:100:ace::1/128
  neighbor BB-BLUE activate
  neighbor BB-BLUE next-hop-self
  neighbor BB-BLUE soft-reconfiguration inbound
  neighbor CONSUMERS activate
  neighbor CONSUMERS next-hop-self
  neighbor CONSUMERS soft-reconfiguration inbound
  neighbor CONSUMERS route-map MED_LEVEL out
  neighbor EX-A activate
  neighbor EX-A next-hop-self
  neighbor EX-A soft-reconfiguration inbound
  neighbor EX-A route-map MED_LEVEL out
 exit-address-family
exit
!
route-map MED_LEVEL permit 5
 set metric 10
exit
!
segment-routing
 traffic-eng
 exit
exit
!
end

```
```
docker exec -it Blue-A vtysh -c show running-con

Building configuration...

Current configuration:
!
frr version 8.3-dev-my-manual-build
frr defaults traditional
hostname Blue-A
service integrated-vtysh-config
!
interface lo
 ipv6 address 2001:db8:6500:100:ace::1/128
exit
!
router bgp 64600
 bgp router-id 10.64.60.1
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp confederation identifier 65000
 bgp confederation peers 64501 64502 64503 64601
 neighbor BB-BLUE peer-group
 neighbor BB-BLUE remote-as 64600
 neighbor CONSUMERS peer-group
 neighbor EX-A peer-group
 neighbor EX-A remote-as 64501
 neighbor blue-b interface peer-group BB-BLUE
 no neighbor blue-b capability extended-nexthop
 neighbor blue-c interface peer-group BB-BLUE
 no neighbor blue-c capability extended-nexthop
 neighbor pe-a interface peer-group CONSUMERS
 neighbor pe-a remote-as 64701
 no neighbor pe-a capability extended-nexthop
 neighbor ex-a interface peer-group EX-A
 no neighbor ex-a capability extended-nexthop
 !
 address-family ipv6 unicast
  network 2001:db8:6500::/48
  network 2001:db8:6500:100:ace::1/128
  neighbor BB-BLUE activate
  neighbor BB-BLUE next-hop-self
  neighbor BB-BLUE soft-reconfiguration inbound
  neighbor CONSUMERS activate
  neighbor CONSUMERS next-hop-self
  neighbor CONSUMERS soft-reconfiguration inbound
  neighbor CONSUMERS route-map MED_LEVEL out
  neighbor EX-A activate
  neighbor EX-A next-hop-self
  neighbor EX-A soft-reconfiguration inbound
  neighbor EX-A route-map MED_LEVEL out
 exit-address-family
exit
!
route-map MED_LEVEL permit 5
 set metric 10
exit
!
segment-routing
 traffic-eng
 exit
exit
!
end
```

```
docker exec -it PE-A vtysh -c show running-con

Building configuration...

Current configuration:
!
frr version 8.3-dev-my-manual-build
frr defaults traditional
hostname PE-A
service integrated-vtysh-config
!
interface cm-a
 ipv6 address 2001:db8:6500:6471::1/64
exit
!
router bgp 64701
 bgp router-id 10.64.70.1
 no bgp ebgp-requires-policy
 no bgp suppress-duplicates
 no bgp default ipv4-unicast
 no bgp network import-check
 neighbor BB peer-group
 neighbor BB remote-as 65000
 neighbor blue-a interface peer-group BB
 no neighbor blue-a capability extended-nexthop
 neighbor green-a interface peer-group BB
 no neighbor green-a capability extended-nexthop
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor BB activate
  neighbor BB soft-reconfiguration inbound
  neighbor blue-a route-map test out
  neighbor green-a route-map test2 out
 exit-address-family
exit
!
route-map test permit 5
 set extcommunity bandwidth 1
exit
!
route-map test2 permit 10
 set extcommunity bandwidth 4
exit
!
segment-routing
 traffic-eng
 exit
exit
!
end

```



## 設計情報
- router-id
    - Blue
        - 10.64.60.1
        - 10.64.60.2
        - 10.64.60.3
    - Green
        - 10.64.61.1
        - 10.64.61.2
        - 10.64.61.3
    - EX
        - 10.64.50.1
        - 10.64.50.2
        - 10.64.50.3
    - CE
        - 10.64.70.1
        - 10.64.70.2
        - 10.64.70.3
    - EA
        - 10.65.10.0
        - 10.65.20.0
        - 10.65.30.0


- BB address
    - 2001:db8:6500::/48 ... AS 65000
        - 2001:db8:6500:100::/56 ... Blue Backbone
            - 2001:db8:6500:100:ace::1/128 ... Blue-A (lo)
            - 2001:db8:6500:100:cafe::1/128 ... Blue-B (lo)
            - 2001:db8:6500:100:beef::1/128 ... Blue-C (lo)
        - 2001:db8:6500:200::/56 ... Green Backbone 
            - 2001:db8:6500:200:ace::1/128 ... Green-A (lo)
            - 2001:db8:6500:200:cafe::1/128 ... Green-B (lo)
            - 2001:db8:6500:200:beef::1/128 ... Green-C (lo)
        - 2001:db8:6500:6451::1/128 ... EX-A (lo)
        - 2001:db8:6500:6452::1/128 ... EX-B (lo)
        - 2001:db8:6500:6453::1/128 ... EX-C (lo)
        - 2001:db8:6500:6471::/64 ... CE-A
            - 2001:db8:6500:6471::1/64 ... CE-A
            - 2001:db8:6500:6471::2/64 ... CM-A
        - 2001:db8:6500:6472::/64 ... CE-B
            - 2001:db8:6500:6472::1/64 ... CE-B
            - 2001:db8:6500:6472::2/64 ... CM-B
        - 2001:db8:6500:6473::/64 ... CE-C
            - 2001:db8:6500:6473::1/64 ... CE-C
            - 2001:db8:6500:6473::2/64 ... CM-C

- 対外アドレス
    - 2001:db8:6510::/48 ... EA-A
        - 2001:db8:6510::1/128 ... EA-A (lo)
    - 2001:db8:6520::/48 ... EA-B
        - 2001:db8:6520::1/128 ... EA-B (lo)
    - 2001:db8:6530::/48 ... EA-C
        - 2001:db8:6530::1/128 ... EA-C (lo)

## コントローラ
### bg-switcher-controller
- 中央コントローラ
- bg-switcher-group リソースを監視
- それらを元に bg-switcher のリソースを作成する
```yaml
spec:
  groups:
    - group:
      color: blue
      - bbrouter: blue-a
      - bbrouter: blue-b
      - bbrouter: blue-c
    - group:
      color: green
      - bbrouter: green-a
      - bbrouter: green-b
      - bbrouter: green-c
  mainColor: blue
```
```yaml
status:
  bbrouters:
    - bbrouter:
      name: blue-a
      color: blue
      created: true
    - bbrouter:
      name: blue-b
      color: blue
      created: true
    - bbrouter:
      name: blue-c
      color: blue
      created: true
    - bbrouter:
      name: green-a
      color: green
      created: true
  mainColor: blue
```

## bg-switcherlet
- 分散コントローラ
  - bg-switcher リソースを監視
    - `name:` に指定されている文字列と自分自身のコンテナ内の環境変数`$NAME`が同じ時だけリコンサイル
    - `isMainColor`の真偽に応じて FRR 内の med を変更する
    - 変更後の med を入れる
```yaml
spec:
  color: green
  isMain: false
```
```yaml
status:
  color: green
  med: 10
```
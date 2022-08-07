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
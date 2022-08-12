# Blue/Green Switcher
## トポロジー
![topo](./memo/topo.svg)
- バックボーンネットワークでも Canary Release がしたい！
    - 2 面の バックボーンネットワークを用意する
    - Blue をユーザが利用しているときは Green を開発する
    - Green の開発が終わったら Green を主系に切り替え，ユーザトラフィックを流す
    - 問題が起きたらすぐに Blue に切り戻す
    - うまく行ったら今度は Blue で開発を行い，開発が終わったら切り替える
    - AS の中 → 外，外 → 中，トランジット，全ての通信でこれを行う


## デモ1
![demo](memo/demo-v3-2.gif)
- Green → Blue に変更させる様子
- 80 秒かけて，一度に 20% ずつ流量を変化
  - これらの値はパラメータとして自由に指定可能
- 左上: CM-A で起動している http サーバに CM-C，EA-B からアクセス
  - AS の 中-中，中-外 の通信
  - このデモでは映してないが，外-外 の通信も可能！
- 左下: PE-A，PE-C，EX-A それぞれの Backbone のリンクに流れているパケットの量を表示
  - 黄色文字: 10 packets/s 以上
- 右上: Canary Release に関するリソースを編集
- 右下: EX のルータにも重みが変わった経路がインストールされている

1. 最初は全て Green
2. リソースを変更 → apply
3. 徐々に流量が変化
4. 全ての パケットが Blue を通るようになる




[設計資料](./memo/design.md)

[TODO](./memo/todo.md)

## 環境の起動
`make tinet-upconf`

## 環境の削除
`make tinet-down`
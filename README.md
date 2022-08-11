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
- Green → Blue に変更させる様子
- 30 秒かけて，一度に 30% ずつ流量を変化
- 変更速度が早いのでたまに少し揺れてる
![demo](memo/demo-v2-1.gif)

## デモ2
- Blue → Gren に変更させる様子
- 80 秒かけて，一度に 20% ずつ流量を変化
- ある程度ゆっくりやれば完全に動く！
  - 運用上十分な対応速度
![demo](memo/demo-v2-2.gif)



[設計資料](./memo/design.md)

[TODO](./memo/todo.md)

## 環境の起動
`make tinet-upconf`

## 環境の削除
`make tinet-down`
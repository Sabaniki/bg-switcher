# seccamp2022 Blue/Green Switcher デザイン
## 概要
- バックボーンネットワークでも Blue/Green デプロイメントがしたい！
    - 2 面の バックボーンネットワークを用意する
    - Blue をユーザが利用しているときは Green を開発する
    - Green の開発が終わったら Green を主系に切り替え，ユーザトラフィックを流す
    - 問題が起きたらすぐに Blue に切り戻す
    - うまく行ったら今度は Blue で開発を行い，開発が終わったら切り替える
- 徐々に切り替えるのが本来だけど，今回はズバっと一気に切り替える

## 基本は vSIX の三角形トポロジー
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
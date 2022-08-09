# TODO
## 環境構築
- [x] change Makefile
- [x] change manager
- [x] 初期状態から変えていない suite_test が致命的な感じで落ちることの解決
  - 色々見たけどわからなかった
  - [issueをみつけた](https://github.com/kubernetes-sigs/kubebuilder/issues/2642)
    - どうやら 4 月の段階で kubebuilder，1.18 がダメらしい
    - 今 1.19 だから流石に 1.18 に... と思って 1.18 にしたけどそれもダメだった
    - suite_test を全てコメントアウトする強行に出て got ことなき
- [x] エラーを直す

```
❯ kind load docker-image ghcr.io/sabaniki/seccamp/bg-switcher-controller:latest
Image: "ghcr.io/sabaniki/seccamp/bg-switcher-controller:latest" with ID "sha256:754eb0ebf6c9b45ad15b2fb2a33624b885a2e732ecc73e055d2ab1beb829d4a0" not yet present on node "kind-control-plane", loading...
ERROR: command "docker save -o /tmp/images-tar1571609728/images.tar ghcr.io/sabaniki/seccamp/bg-switcher-controller:latest" failed with error: exit status 1
Command Output: failed to save image: invalid output path: directory "/tmp/images-tar1571609728" does not exist
```

  - [issueを見つけた](https://github.com/kubernetes-sigs/kind/issues/2535)
  - docker を get.docker.com から再インストールでかいけつ

- [x] postfini が本当に使えないか調べる
  - 分散コントローラは docker-compose で上げることにした
  - tinet の up/down と連動してほしい
  - up は postinit が動く
  - down の postfini は動いていない気がする

## 2022/08/09 午前
- [x] Stakeholderリスト作る
- [x] CE->PE名前を変える
- [x] EnvとかCli-argつかって, imageを共通化
- [x] N% deployをどういうoperation体験でやるかどうかを整理する
  - [x] 要素の検証
- [ ] /etc/hosts にルータ書いて traceroute の結果を見やすく

## 2022/08/09 午後
- [ ] N% deploy実装
  - [x] よく考えたらデータ構造が大きく変わるので考える
    - [x] group の spec
    - [x] group の status
    - [x] let の spec
    - [x] let の status
  - [ ] まずは let の方が自分に設定を入れることができる
    - [ ] 
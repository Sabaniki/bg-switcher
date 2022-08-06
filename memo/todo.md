# TODO
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
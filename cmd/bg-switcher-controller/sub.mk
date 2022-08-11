BG_SWITCHER_CONTROLLER_IMG := $(REGISTRY_BASE)/bg-switcher-controller:$(DOCKER_IMG_TAG)

bg-switcher-controller-dev: bg-switcher-controller-docker-build
	kind load docker-image ghcr.io/sabaniki/seccamp/bg-switcher-controller:latest &&\
	kubectl rollout restart -n bg-switcher-system deployment bg-switcher-bg-switcher-controller-manager

bg-switcher-controller-docker-all: bg-switcher-controller-docker-build bg-switcher-controller-docker-push
bg-switcher-controller-docker-build: test
	docker build \
		--file cmd/bg-switcher-controller/Dockerfile \
		--tag ${BG_SWITCHER_CONTROLLER_IMG} .
bg-switcher-controller-docker-push:
	docker push ${BG_SWITCHER_CONTROLLER_IMG}
bg-switcher-controller-build: #generate fmt vet
	go build -o ./cmd/bg-switcher-controller/a.out ./cmd/bg-switcher-controller

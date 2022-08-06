BG_SWITCHER_CONTROLLER_IMG := $(REGISTRY_BASE)/bg-switcher-controller:$(DOCKER_IMG_TAG)

bg-switcher-controller-docker-all: bg-switcher-controller-docker-build bg-switcher-controller-docker-push
bg-switcher-controller-docker-build: test
	docker build \
		--file cmd/bg-switcherlet/Dockerfile \
		--tag ${BG_SWITCHER_CONTROLLER_IMG} .
bg-switcher-controller-docker-push:
	docker push ${BG_SWITCHER_CONTROLLER_IMG}
bg-switcher-controller-build: #generate fmt vet
	go build -o ./cmd/bg-switcher-controller/a.out ./cmd/bg-switcher-controller

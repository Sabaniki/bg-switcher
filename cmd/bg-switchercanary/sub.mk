BG_SWITCHERCANARY_IMG := $(REGISTRY_BASE)/bg-switchercanary:$(DOCKER_IMG_TAG)

bg-switchercanary-docker-all: bg-switchercanary-docker-build bg-switchercanary-docker-push
bg-switchercanary-docker-build: test
	docker build \
		--file cmd/bg-switchercanary/Dockerfile \
		--tag ${BG_SWITCHERCANARY_IMG} .
bg-switchercanary-docker-push:
	docker push ${BG_SWITCHERCANARY_IMG}
bg-switchercanary-build: #generate fmt vet
	go build -o ./cmd/bg-switchercanary/a.out ./cmd/bg-switchercanary

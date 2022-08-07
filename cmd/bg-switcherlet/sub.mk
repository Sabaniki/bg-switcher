BG_SWITCHERLET_IMG := $(REGISTRY_BASE)/bg-switcherlet:$(DOCKER_IMG_TAG)

bg-switcherlet-docker-all: bg-switcherlet-docker-build bg-switcherlet-docker-push
bg-switcherlet-docker-build: test
	python3 dirtyhack.py
bg-switcherlet-docker-push:
	docker push ${BG_SWITCHERLET_IMG}
bg-switcherlet-build: #generate fmt vet
	go build -o ./cmd/bg-switcherlet/a.out ./cmd/bg-switcherlet

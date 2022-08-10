.PHONY: all
all: build push

.PHONY: build
build:
	docker build \
		--file Dockerfile \
		--tag watch-linkstats .

.PHONY: push
push:
	docker push watch-linkistats
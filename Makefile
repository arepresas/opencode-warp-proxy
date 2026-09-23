IMAGE     := overlag/opencode-warp-proxy
TAG       := 1.0.0
PLATFORMS := linux/amd64,linux/arm64
BUILDER   := owarp-builder

.PHONY: help build publish login clean builder verify

help:
	@echo "Targets:"
	@echo "  publish    Multi-arch build + push :$(TAG) and :latest"
	@echo "             Platforms: $(PLATFORMS)"
	@echo "  build      Single-arch local build via docker compose (no push)"
	@echo "  login      Docker Hub login"
	@echo "  verify     Inspect published manifest"
	@echo "  clean      Remove local images and builder"

builder:
	@docker buildx create --name $(BUILDER) --driver docker-container --use 2>/dev/null || docker buildx use $(BUILDER)
	docker buildx inspect --bootstrap

publish: builder
	docker buildx build \
		--platform $(PLATFORMS) \
		--tag $(IMAGE):$(TAG) \
		--tag $(IMAGE):latest \
		--push \
		.

build:
	docker compose build

login:
	docker login -u overlag

verify:
	docker buildx imagetools inspect $(IMAGE):$(TAG)

clean:
	docker rmi $(IMAGE):$(TAG) $(IMAGE):latest opencode-warp-proxy:local 2>/dev/null || true
	docker buildx rm $(BUILDER) 2>/dev/null || true


DISTRO_NAME=alpine
IMAGE_REGISTRY=073455283520.dkr.ecr.us-east-2.amazonaws.com
IMAGE_NAME:=fips/nginx
IMAGE_TAG:=1.17-$(DISTRO_NAME)

build:
	@docker image build \
		-f ./$(DISTRO_NAME)/Dockerfile \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

build-dev:
	@docker image build \
		-f ./$(DISTRO_NAME)/Dockerfile \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

push: build
	@docker image push $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	@docker image rm $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	@docker image rm $(IMAGE_NAME):$(IMAGE_TAG)

test:
	@docker container run --rm -it --entrypoint=/bin/sh $(IMAGE_NAME):$(IMAGE_TAG) nginx -V
	@docker container run --rm -it --entrypoint=/bin/sh $(IMAGE_NAME):$(IMAGE_TAG) openssl version


IMAGE_REGISTRY=073455283520.dkr.ecr.us-east-2.amazonaws.com
IMAGE_NAME:=fips/centos
IMAGE_TAG:=7

build:
	@docker image build \
		--no-cache \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

build-dev:
	@docker image build \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

push: build
	@docker image push $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	@docker image rm $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	@docker image rm $(IMAGE_NAME):$(IMAGE_TAG)

test:
	@docker container run --rm -it $(IMAGE_NAME):$(IMAGE_TAG) openssl version
	@docker container run --rm -it $(IMAGE_NAME):$(IMAGE_TAG) printenv

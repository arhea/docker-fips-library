
IMAGE_NAME:=arhea/amazonlinux
IMAGE_TAG:=2-fips

build:
	@docker image build -t $(IMAGE_NAME):$(IMAGE_TAG) .

push:
	docker image push $(IMAGE_NAME):$(IMAGE_TAG)

clean:
	@docker image rm $(IMAGE_NAME):$(IMAGE_TAG)

test:
	@docker container run --rm -it $(IMAGE_NAME):$(IMAGE_TAG) openssl version

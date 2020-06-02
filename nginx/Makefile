
DISTRO_NAME=alpine
IMAGE_REGISTRY=073455283520.dkr.ecr.us-east-2.amazonaws.com
IMAGE_NAME:=fips/nginx
IMAGE_TAG:=1.17-$(DISTRO_NAME)

define DEFAULT_SERVER_CONFIG
server {
	listen [::]:80 default_server;
	listen 80 default_server;

	server_name _;

	return 301 https://$$host$$request_uri;
}

server {
	listen [::]:443 ssl http2;
	listen 443 ssl http2;

	server_name _;

	# SSL Configuration
	include h5bp/ssl/ssl_engine.conf;
	include h5bp/ssl/certificate_files.conf;
	include h5bp/ssl/policy_fips.conf;

	# Custom error pages
	include h5bp/errors/custom_errors.conf;

	# Include the basic h5bp config set
	include h5bp/basic.conf;

	# Path for static files
	location / {
		root   /usr/share/nginx/html;
		index  index.html index.htm;
	}
}
endef

export DEFAULT_SERVER_CONFIG

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

gen-certs:
ifeq (,$(wildcard ./default.key))
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout default.key -out default.crt
endif

gen-conf:
	@echo "$$DEFAULT_SERVER_CONFIG" > default.conf

test: gen-certs gen-conf
	@docker container run --rm --name=fips-nginx \
		-p 8080:80 \
		-p 8443:443 \
		-v $(shell pwd)/default.conf:/etc/nginx/conf.d/default.conf \
		-v $(shell pwd)/default.crt:/etc/nginx/certs/default.crt \
   		-v $(shell pwd)/default.key:/etc/nginx/certs/default.key \
		$(IMAGE_NAME):$(IMAGE_TAG)

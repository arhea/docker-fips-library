# NGINX

This container is based on the [official NGINX container image](https://github.com/nginxinc/docker-nginx) from the open source NGINX project. This container also contains the [NGINX configuration from the H5BP project](https://github.com/h5bp/server-configs-nginx). This configuration contains best practice configurations, optimizations, and security helpers.

## Usage

To create a FIPS compliant endpoint, first create an OpenSSL certificate with a FIPS enabled installation of OpenSSL.

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout default.key -out default.crt
```

Then create a configuration for the server that matches your specifications.

```text
# default.conf

server {
  listen [::]:80 default_server;
  listen 80 default_server;

  server_name _;

  return 301 https://$host$request_uri;
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
```

Now that we have a configuration, run the container.

```bash
docker container run --rm --name=fips-nginx \
    -p 8443:443 \
    -v $(pwd)/default.crt:/etc/nginx/certs/default.crt \
    -v $(pwd)/default.key:/etc/nginx/certs/default.key \
    -v $(pwd)/mysite.conf:/etc/nginx/conf.d/default.conf \
    fips/nginx:1.17.10-alpine
```

## Building

This image supports multiple base images and different configurations.

| Options | Default | Supported Values | Description |
|---|---|---|
| DISTRO_NAME | `alpine` | `alpine`, `centos`, `amazonlinux` | Configure which base image to use for the nginx container. |
| IMAGE_REGISTRY | `073455283520.dkr.ecr.us-east-2.amazonaws.com` | Any Docker Registry | The URL of the Docker registry to push the images. |
| IMAGE_NAME | `fips/nginx` | Any | The name of the image repository within the Docker registry. |
| IMAGE_TAG | `1.17-$(DISTRO_NAME)` | Any | The image tag associated with the build. |
| NGINX_VERSION | `1.17.10` | [Versions](http://nginx.org/en/download.html) | The NGINX version to build. |

```bash
make DISTRO_NAME=alpine build
make DISTRO_NAME=centos build
make DISTRO_NAME=amazonlinux build
```

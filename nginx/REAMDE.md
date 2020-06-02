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

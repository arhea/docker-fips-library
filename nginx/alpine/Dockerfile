FROM 073455283520.dkr.ecr.us-east-2.amazonaws.com/fips/alpine:3

ARG NGINX_VERSION=1.17.10

RUN mkdir -p /tmp \
    && cd /tmp \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk add --no-cache gnupg gzip perl pcre zlib ca-certificates tzdata \
    && apk add --no-cache --virtual .build-deps \
        wget \
        gcc \
        libc-dev \
        make \
        tar \
        linux-headers \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        libedit-dev \
        bash \
        alpine-sdk \
        findutils \
        pcre-dev \
        zlib-dev \
        coreutils \
    && cd /tmp \
    && wget --quiet http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && tar -xzf nginx-$NGINX_VERSION.tar.gz \
    && cd nginx-$NGINX_VERSION \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --with-select_module \
        --with-poll_module \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-http_perl_module=dynamic \
        --with-perl=/usr/bin/perl \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-mail=dynamic \
        --with-mail_ssl_module \
        --with-stream=dynamic \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-stream_ssl_preread_module \
        --with-compat \
        --user=nginx \
        --group=nginx \
        --with-ld-opt="-L/usr/local/ssl/lib -Wl,-rpath,/usr/local/ssl/lib -lssl -lcrypto -ldl -lz" \
        --with-cc-opt="-I/usr/local/ssl/include" \
    && make \
    && make install \
    && cd /root \
    && apk del .build-deps \
    && rm -rf /tmp \
    && apk add --no-cache curl tzdata ca-certificates \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mkdir -p /usr/share/nginx \
    && mkdir -p /var/cache/nginx \
    && mv /etc/nginx/html /usr/share/nginx/html \
    && chown nginx:nginx -R /usr/share/nginx \
    && chown nginx:nginx -R /var/cache/nginx \
    && rm -f /etc/nginx/*.default

COPY shared/nginx/nginx.conf /etc/nginx/nginx.conf
COPY shared/nginx/mime.types /etc/nginx/mime.types
COPY shared/nginx/h5bp /etc/nginx/h5bp
COPY shared/nginx/conf.d /etc/nginx/conf.d
COPY shared/docker-entrypoint.sh /
COPY shared/docker-entrypoint.d /docker-entrypoint.d

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

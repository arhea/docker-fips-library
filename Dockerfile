FROM alpine:latest

# NGINX Configuration
ARG NGINX_VER=1.17.10

# OpenSSL FIPS Configuration
ARG OPENSSL_FIPS_VER=2.0.16
ARG OPENSSL_FIPS_HMACSHA1=e8dbfa6cb9e22a049ec625ffb7ccaf33e6116598
ARG OPENSSL_FIPS_HASH=a3cd13d0521d22dd939063d3b4a0d4ce24494374b91408a05bdaca8b681c63d4

# OpenSSL Configuration
ARG OPENSSL_VER=1.0.2u
ARG OPENSSL_HASH=ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16

RUN apk update \
    && cd /root \
    && apk upgrade \
    && apk add --update \
        wget \
        gcc \
        gzip \
        tar \
        libc-dev \
        ca-certificates \
        perl \
        make \
        coreutils \
        gnupg \
        linux-headers\
        zlib-dev \
        openssl \
        pcre-dev \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        mercurial \
        bash \
        alpine-sdk \
        findutils \
    && wget --quiet https://www.openssl.org/source/openssl-fips-$OPENSSL_FIPS_VER.tar.gz \
    && openssl sha1 -hmac etaonrishdlcupfm openssl-fips-$OPENSSL_FIPS_VER.tar.gz | grep $OPENSSL_FIPS_HMACSHA1 \
    && apk del openssl \
    && wget --quiet https://www.openssl.org/source/openssl-fips-$OPENSSL_FIPS_VER.tar.gz.asc \
    && echo "$OPENSSL_FIPS_HASH openssl-fips-$OPENSSL_FIPS_VER.tar.gz" | sha256sum -c - | grep OK \
    && tar -xzf openssl-fips-$OPENSSL_FIPS_VER.tar.gz \
    && cd openssl-fips-$OPENSSL_FIPS_VER \
    && ./config \
    && make \
    && make install \
    && cd /root \
    && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz \
    && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz.asc \
    && echo "$OPENSSL_HASH openssl-$OPENSSL_VER.tar.gz" | sha256sum -c - | grep OK \
    && tar -xzf openssl-$OPENSSL_VER.tar.gz \
    && cd openssl-$OPENSSL_VER \
    && perl ./Configure linux-x86_64 --prefix=/usr \
                                     --libdir=lib \
                                     --openssldir=/etc/ssl \
                                     fips shared zlib enable-montasm enable-md2 enable-ec_nistp_64_gcc_128 \
                                     -DOPENSSL_NO_BUF_FREELISTS \
                                     -Wa,--noexecstack enable-ssl2 \
    && make \
    && make install_sw

RUN cd /root \
    && wget --quiet http://nginx.org/download/nginx-$NGINX_VER.tar.gz \
    && tar -xzf nginx-$NGINX_VER.tar.gz \
    && cd nginx-$NGINX_VER \
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
        --with-perl_modules_path=/usr/share/perl/5.26.1 \
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
        --with-openssl=/root/openssl-$OPENSSL_VER \
        --user=nginx \
        --group=nginx \
    && make \
    && make install \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

RUN rm -rf /root/openssl* /root/nginx* /root/patches /var/cache/apk/* /root/.gnupg/ ~/.ash_history /root/.wget-hsts /root/ \
    && apk del wget gcc gzip tar libc-dev ca-certificates perl make coreutils gnupg linux-headers    

ENV OPENSSL_FIPS=1

COPY ./nginx /etc/nginx

EXPOSE 80 443

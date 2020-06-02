FROM alpine:3

# OpenSSL FIPS Configuration
ARG OPENSSL_FIPS_VERSION=2.0.16
ARG OPENSSL_FIPS_HASH=a3cd13d0521d22dd939063d3b4a0d4ce24494374b91408a05bdaca8b681c63d4

# OpenSSL Configuration
ARG OPENSSL_VERSION=1.0.2k
ARG OPENSSL_HASH=6b3977c61f2aedf0f96367dcfb5c6e578cf37e7b8d913b4ecb6643c3cb88d8c0

RUN apk update \
    && mkdir -p /tmp \
    && cd /tmp \
    && apk add ca-certificates \
    && apk add --no-cache --virtual .build-deps \
        wget \
        gcc \
        gzip \
        tar \
        libc-dev \
        ca-certificates \
        perl \
        make \
        coreutils \
        linux-headers \
        zlib-dev \
        gnupg \
    && wget --quiet https://www.openssl.org/source/openssl-fips-$OPENSSL_FIPS_VERSION.tar.gz \
    && wget --quiet https://www.openssl.org/source/openssl-fips-$OPENSSL_FIPS_VERSION.tar.gz.asc \
    && echo "$OPENSSL_FIPS_HASH openssl-fips-$OPENSSL_FIPS_VERSION.tar.gz" | sha256sum -c - | grep OK \
    && tar -xzf openssl-fips-$OPENSSL_FIPS_VERSION.tar.gz \
    && cd openssl-fips-$OPENSSL_FIPS_VERSION \
    && ./config \
    && make \
    && make install \
    && cd /tmp \
    && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz \
    && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz.asc \
    && echo "$OPENSSL_HASH openssl-$OPENSSL_VERSION.tar.gz" | sha256sum -c - | grep OK \
    && tar -xzf openssl-$OPENSSL_VERSION.tar.gz \
    && cd openssl-$OPENSSL_VERSION \
    && perl ./Configure linux-x86_64 \
        --with-fipsdir=/usr/local/ssl/fips-2.0 \
        fips shared no-ssl2 no-ssl3 \
    && make \
    && make install \
    && ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl \
    && rm -rf /tmp \
    && apk del .build-deps   

ENV OPENSSL_FIPS 1
ENV PATH /usr/local/ssl/bin::$PATH


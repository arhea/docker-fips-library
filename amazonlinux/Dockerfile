FROM amazonlinux:2

RUN yum update -y \
    && yum install -y dracut-fips openssl

ENV OPENSSL_FIPS=1

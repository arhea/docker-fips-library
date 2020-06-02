FROM amazonlinux:2

RUN yum update -y \
    && yum install -y dracut-fips openssl \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV OPENSSL_FIPS=1

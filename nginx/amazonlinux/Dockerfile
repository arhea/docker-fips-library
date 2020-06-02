FROM 073455283520.dkr.ecr.us-east-2.amazonaws.com/fips/amazonlinux:2

ARG NGINX_VERSION=1.17.10

RUN echo "[nginx]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=https://nginx.org/packages/mainline/centos/7/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo \
    && yum update -y \
    && yum install -y nginx-$NGINX_VERSION openssl dracut-fips \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

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

FROM php:7.4-fpm-alpine

ENV USER=sistem \
    GRUP=sistem \
    WORKD=/var/www \
    UID=1000 \
    GID=1000 \
    NGEV=1.19.6 \
    FORBULID="freetype-dev jpeg-dev libwebp-dev libxpm-dev libzip-dev libc-dev zlib-dev libpng-dev openssl-dev pcre-dev icu-dev build-base linux-headers gcc" \
    PREFIX=/usr/local

RUN \
    sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&\
    apk upgrade --update-cache --available &&\
    addgroup -g 1000 -S $GRUP &&\
    addgroup -S cctv -g 1002 &&\ 
    adduser --disabled-password --gecos "" --home "$WORKD" --ingroup "$GRUP" --no-create-home --uid "$UID" "$USER" &&\
    addgroup "$USER" cctv &&\
    apk add --no-cache \
    bash curl wget git zip unzip ca-certificates util-linux \
    $FORBULID \
    pcre icu-libs zlib \
    freetype jpeg libwebp libxpm \
    cpulimit py3-pip supervisor composer \
    dcron libcap && \
    pip3 install --upgrade pip && \
    docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype && \
    docker-php-ext-install bcmath pcntl sysvsem pdo_mysql sockets gd intl opcache exif && \
    pip3 install --no-cache-dir --upgrade streamlink && \
    mkdir -p /var/cache/nginx/ && \
    mkdir -p /var/log/nginx/ && \
    mkdir -p /etc/nginx/config/ && \
    mkdir -p $WORKD/cron/ && \
    chown -R $USER:$GRUP /run && \
    chown -R $USER:$GRUP $WORKD && \
    chown -R $USER:$GRUP /var/cache/nginx/ && \
    chown -R $USER:$GRUP /var/log/nginx/ && \
    chown -R $USER:$GRUP /etc/nginx/config/ && \
    chown $USER:$GRUP /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond  && \  
    cd /tmp && \
    wget http://nginx.org/download/nginx-$NGEV.tar.gz && \
    tar xzf nginx-$NGEV.tar.gz && \
    cd /tmp/nginx-$NGEV && \
    ./configure \ 
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    #https://github.com/iphoting/heroku-buildpack-php-tyler/issues/19#issue-11272482
    --user=$USER \
    --group=$GRUP \
    # https://www.nginx.com/resources/wiki/modules/
    # https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#modules_not_default
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_realip_module \
    --with-http_v2_module && \
    make && \
    make install && \
    apk update && apk del $FORBULID && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Copy ffmpeg (THIS BAD?)
#COPY --from=repo.volcanoyt.com/base_ffmpeg-snapshot-alpine:latest /usr/local /usr/local

# Copy startup
COPY /config/entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

# Switch to use a non-root user from here now
USER $USER

EXPOSE 8888

RUN php -v && php -m && composer -V

# Let script run after all done
ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
FROM ubuntu:14.04

MAINTAINER Gary Chen <cutedogspark@gmail.comm>

ENV DEBIAN_FRONTEND noninteractive

# update and upgrade packages
RUN apt-get -y  update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y make build-essential wget
RUN apt-get install -y cron logrotate 
RUN apt-get install -y wget curl
RUN apt-get install -y pgp yasm 

# ffmpeg
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:mc3man/trusty-media
RUN apt-get update
RUN apt-get install -y ffmpeg

# nginx dependencies
RUN apt-get -q -y build-dep nginx 
RUN apt-get install -y libpcre3-dev zlib1g-dev libssl-dev

# NGINX Version Setting
ENV NGINX_VERSION 1.11.3
ENV NGINX_RTMP_MODULE_VERSION 1.1.9

# create build directories
# /src  , /config , /logs
# /data    (nginx stream file folder)
# /static  (nginx static page)
# /record  
RUN mkdir /src && mkdir /config && mkdir /logs && mkdir /data && mkdir /static && mkdir /record

# Get Nginx source
RUN cd /src && wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && tar zxf nginx-$NGINX_VERSION.tar.gz && rm nginx-$NGINX_VERSION.tar.gz

# Get Nginx-RTMP module
RUN cd /src && wget https://github.com/arut/nginx-rtmp-module/archive/v$NGINX_RTMP_MODULE_VERSION.tar.gz && tar zxf v$NGINX_RTMP_MODULE_VERSION.tar.gz && rm v$NGINX_RTMP_MODULE_VERSION.tar.gz && mv nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION nginx-rtmp-module

# Compile Nginx  ( --with-debug )
RUN cd /src/nginx-$NGINX_VERSION \
    && ./configure \
        --add-module=/src/nginx-rtmp-module \
        --conf-path=/config/nginx.conf \
        --error-log-path=/logs/nginx_error.log \
        --http-log-path=/logs/nginx_access.log \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-file-aio \
        --with-debug 
RUN cd /src/nginx-$NGINX_VERSION && make && make install

        
ADD nginx/nginx.conf /config/nginx.conf
ADD static /static

# Expose ports.
EXPOSE 80
EXPOSE 443
EXPOSE 1395

WORKDIR /data
CMD ["/usr/local/nginx/sbin/nginx", "-c", "/config/nginx.conf"]




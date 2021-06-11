FROM registry.cn-hangzhou.aliyuncs.com/hxly/inspur-alpine-3.10:5.0.0
LABEL maintainer="wangyutang@inspur.com"
EXPOSE 22 3000
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories;\
    apk update;\
    apk  add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata
RUN apk add build-base;\
    gcc -v;\
    cd /tmp;\
    wget http://www.zlib.net/zlib-1.2.11.tar.gz;\
    tar -zxvf zlib-1.2.11.tar.gz ;\
    cd zlib-1.2.11;\
    ./configure --prefix=/usr/local/zlib;\
    make && make install;\
    cd /tmp;\
    wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz;\
    tar -zxvf openssl-1.1.1g.tar.gz;\
    cd openssl-1.1.1g;\
    ./config --prefix=/usr/local/ssl -d shared;\
    make && make install;\
    echo '/usr/local/ssl/lib' >> /etc/ld.so.conf;\
    ldconfig -v;\
    cd /tmp;\
    wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/openssh-8.4p1.tar.gz;\
    cd openssh-8.4p1;\
    ./configure --prefix=/usr/local/openssh --with-zlib=/usr/local/zlib --with-ssl-dir=/usr/local/ssl;\
    make && make install;\
    
    
    

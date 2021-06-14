FROM registry.cn-hangzhou.aliyuncs.com/hxly/inspur-alpine-3.10:5.0.0
LABEL maintainer="wangyutang@inspur.com"
EXPOSE 22 3000
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories;\
    apk update;\
    apk add \
    build-base\
    perl\
    linux-headers
COPY zlib-1.2.11.tar.gz  /tmp/
COPY openssl-1.1.1g.tar.gz  /tmp/
COPY openssh-8.4p1.tar.gz  /tmp/
#安装zlib
RUN cd /tmp;\
    tar -zxvf zlib-1.2.11.tar.gz ;\
    cd zlib-1.2.11;\
    ./configure --prefix=/usr/local/zlib;\
   make && make install;
#安装openssl
RUN cd /tmp;\
    tar -zxvf openssl-1.1.1g.tar.gz;\
    cd openssl-1.1.1g;\
    ./config --prefix=/usr/local/ssl -d shared;\
    make && make install;
#安装openssh  
RUN cd /tmp;\
    tar zxvf openssh-8.4p1.tar.gz;\
    cd openssh-8.4p1;\
    ./configure --prefix=/usr/local/openssh --with-zlib=/usr/local/zlib --with-ssl-dir=/usr/local/ssl   --without-openssl-header-check;\
    make && make install;\
    echo 'PermitRootLogin yes' >>/usr/local/openssh/etc/sshd_config;\
    echo 'PubkeyAuthentication yes' >>/usr/local/openssh/etc/sshd_config;\
    echo 'PasswordAuthentication yes' >>/usr/local/openssh/etc/sshd_config;\
    cp /usr/local/openssh/bin/ssh /usr/bin/ssh;\
    cp /usr/local/openssh/sbin/sshd /usr/sbin/sshd;\
    mkdir /etc/ssh;\
    cp /usr/local/openssh/etc/sshd_config /etc/ssh/sshd_config;\
    cp /usr/local/openssh/etc/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub;\
    ssh -V;\
    rm -rf /tmp/openssh-8.4p1;\
    rm -rf /tmp/openssl-1.1.1g.tar.gz;\
    rm -rf /tmp/zlib-1.2.11.tar.gz;\
    rm /tmp/zlib-1.2.11.tar.gz;\
    rm /tmp/openssl-1.1.1g.tar.gz;\
    rm /tmp/openssh-8.4p1.tar.gz;
    
    
    

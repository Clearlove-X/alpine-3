# build frrm source
FROM gitea/gitea:1.13.0
LABEL maintainer="wangyutang@inspur.com"

RUN apk update;\
    apk add \
    gcc\
    g++\
    perl\
    make\
    linux-headers
 
COPY zlib-1.2.11.tar.gz  /tmp/
COPY openssl-1.1.1g.tar.gz  /tmp/
COPY openssh-8.6p1.tar.gz  /tmp/

#安装zlib
RUN cd /tmp;\
    tar -zxvf zlib-1.2.11.tar.gz ;\
    cd zlib-1.2.11;\
    ./configure;\
   make && make install;
   
 #安装openssl
RUN cd /tmp;\
    tar -zxvf openssl-1.1.1g.tar.gz;\
    cd openssl-1.1.1g;\
    ./config ;\
    make && make install;
    
#安装openssh  
RUN cd /tmp;\
    tar zxvf openssh-8.6p1.tar.gz;\
    cd openssh-8.6p1;\
    ./configure;\
    make && make install;\
    mv /usr/bin/ssh /usr/bin/ssh.bak;\
    mv /usr/sbin/sshd /usr/sbin/sshd.bak;\
    cp /usr/local/bin/ssh /usr/bin/ssh;\
    cp /usr/local/sbin/sshd /usr/sbin/sshd;





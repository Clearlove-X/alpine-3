# build frrm source
FROM golang:1.14-alpine AS installer
RUN set -ex;\
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories;\
    apk add --no-cache build-base git nodejs npm;
WORKDIR /tmp
ARG GITEA_VERSION=1.13.0
# Ref: https://docs.gitea.io/en-us/install-from-source/
RUN set -ex;\
    git clone https://gitee.com/klaywang/gitea2.git -b v1.13.0.1  gitea;
WORKDIR /tmp/gitea
RUN set -ex;\
    npm config set registry https://registry.npm.taobao.org;\
    TAGS="bindata" make build;
RUN set -ex;\
    ls -l;\
    cp gitea /;

FROM registry.cn-hangzhou.aliyuncs.com/hxly/inspur-alpine-3.10:5.0.0
LABEL maintainer="wangyutang@inspur.com"
EXPOSE 22 3000
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories;\
    apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    openssh \
    linux-pam \
    s6 \
    sqlite \
    su-exec \
    tzdata
RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd
ENV USER git
ENV GITEA_CUSTOM=/data/gitea

ENTRYPOINT ["/sbin/tini","--","/usr/bin/entrypoint"]
CMD ["/app/gitea/gitea"]

COPY --from=installer /tmp/gitea/docker/root /
COPY --from=installer /gitea /app/gitea/gitea
RUN ln -s /app/gitea/gitea /usr/local/bin/gitea;\
    chmod +x /usr/bin/entrypoint;\
    apk upgrade;

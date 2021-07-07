# build frrm source
FROM registry.cn-hangzhou.aliyuncs.com/hxly/gitea:alpine-with-openssh8.6 AS installer
RUN  ls /usr/local/openssh/bin;\
     ls /usr/local/openssh/sbin;


FROM registry.cn-hangzhou.aliyuncs.com/hxly/gitea:3.12.0
LABEL maintainer="wangyutang@inspur.com"


COPY --from=installer /usr/local/openssh/bin/scp /usr/bin/scp
COPY --from=installer /usr/local/openssh/bin/sftp /usr/bin/sftp
COPY --from=installer /usr/local/openssh/bin/ssh /usr/bin/ssh
COPY --from=installer /usr/local/openssh/bin/ssh-add /usr/bin/ssh-add
COPY --from=installer /usr/local/openssh/bin/ssh-agent /usr/bin/ssh-agent
COPY --from=installer /usr/local/openssh/bin/ssh-keygen /usr/bin/ssh-keygen
COPY --from=installer /usr/local/openssh/bin/ssh-keyscan /usr/bin/ssh-keyscan
COPY --from=installer /usr/local/openssh/sbin/sshd /usr/sbin/sshd
COPY --from=installer /usr/local/openssh/etc/sshd_config /etc/ssh/sshd_config
COPY --from=installer /usr/local/openssh/etc/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub


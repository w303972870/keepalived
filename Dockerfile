FROM alpine:latest
MAINTAINER Eric.wang wdc-zhy@163.com

RUN mkdir -p /data/conf/ /data/logs/ /var/run/keepalived

ADD README.md /root/
ADD docker-entrypoint.sh /root/

RUN apk add --no-cache keepalived tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apk del gcc g++ openssl-dev zlib-dev perl-dev pcre-dev make git autoconf automake libtool &&  rm -rf /var/cache/apk/* && \
    mv /etc/keepalived/keepalived.conf /data/conf/ && chmod +x /root/docker-entrypoint.sh


ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD ["/usr/sbin/keepalived" , "-f" , "/data/conf/keepalived.conf" ,"-l" , "-n" , "-D"]


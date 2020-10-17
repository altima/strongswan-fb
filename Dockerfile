FROM alpine

RUN set -xe \
    && apk add --no-cache iptables openssl strongswan util-linux \
    && ln -sf /etc/ipsec.d/ipsec.conf /etc/ipsec.conf \
    && ln -sf /etc/ipsec.d/ipsec.secrets /etc/ipsec.secrets

COPY init.sh /init.sh
COPY entrypoint.sh /entrypoint.sh

VOLUME /etc/ipsec.d /etc/strongswan.d

ENV SERVER_FQDN=remote.example.com
ENV SERVER_NET=192.168.42.0
ENV SERVER_IP=192.168.42.10
ENV FB_FQDN=myfb.myfritz.net
ENV FB_NET=192.168.178.0
ENV VPN_PSK=S3cret123!

EXPOSE 500/udp 4500/udp

RUN chmod +x /entrypoint.sh /init.sh

ENTRYPOINT ["/entrypoint.sh"]
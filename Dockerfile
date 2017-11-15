FROM lsiobase/alpine:3.6

MAINTAINER gwelican <superfly@gwelican.eu>

RUN addgroup -S openvpn && \
    adduser -SD -s /sbin/nologin -h /var/lib/openvpn -g openvpn -G openvpn openvpn && \
    apk --no-cache add iptables ip6tables libcap openvpn sudo && \
    setcap cap_net_admin+ep /usr/sbin/openvpn

COPY root/ /

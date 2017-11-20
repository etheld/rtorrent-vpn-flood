FROM lsiobase/alpine:3.6

MAINTAINER gwelican <superfly@gwelican.eu>

ENV OPENVPN_USERNAME OPENVPN_PASSWORD OPENVPN_CONFIG 
ENV DOCKERIZE_VERSION v0.5.0

RUN apk --no-cache add iptables ip6tables libcap openvpn sudo openssl rtorrent screen yarn nodejs-npm && \
    setcap cap_net_admin+ep /usr/sbin/openvpn && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    apk add --update --virtual build-dependencies g++ make openssl python && \
    wget https://github.com/jfurrow/flood/archive/master.zip && \
    unzip -q master.zip -d / && \
    rm master.zip && \
    mv /flood-master /flood && \
    mv /flood/config.template.js /flood/config.js && \
    cd /flood && yarn install


RUN npm install -g node-gyp

RUN cd /flood && npm install && npm run build

RUN apk del --virtual build-dependencies
RUN s6-rmrf /etc/s6/services/s6-fdholderd/down

RUN apk add --no-cache ulogd
# RUN apk --no-cache add yarn nodejs-npm
# RUN cd /flood && yarn install

VOLUME [ "/data", "/config" ]
COPY root/ /

FROM lsiobase/alpine:3.6

LABEL AUTHOR gwelican <superfly@gwelican.eu>

ENV OPENVPN_USERNAME=""
ENV OPENVPN_PASSWORD=""
ENV OPENVPN_CONFIG="/config/default.vpb"
ENV FLOOD_PASSWORD="flood"
ENV PUID="1026"
ENV PGID="100"
ENV DOCKERIZE_VERSION v0.5.0

RUN apk --no-cache add iptables ip6tables libcap openvpn sudo openssl rtorrent screen yarn nodejs-npm curl && \
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
    cd /flood && yarn install && npm install && npm run build && \
    npm install -g node-gyp && \
    apk del --virtual build-dependencies && \
    s6-rmrf /etc/s6/services/s6-fdholderd/down

VOLUME [ "/data", "/config" ]
COPY root/ /

ARG BUILD_DATE
ARG VCS_REF

#RUN cd /flood && npm install && npm run build
#RUN cd /flood && npm install --production && npm run build
#EXPOSE 3000

#RUN apk del --virtual build-dependencies
#RUN s6-rmrf /etc/s6/services/s6-fdholderd/down

#RUN apk add --no-cache ulogd
# RUN apk --no-cache add yarn nodejs-npm
# RUN cd /flood && yarn install

#VOLUME [ "/data", "/config" ]
#COPY root/ /
#RUN apk del --virtual build-dependencies
#RUN s6-rmrf /etc/s6/services/s6-fdholderd/down

#RUN apk add -t build-dependencies build-base git libtool automake autoconf wget tar xz zlib-dev cppunit-dev libressl-dev ncurses-dev curl-dev binutils linux-headers file && \
    git clone https://github.com/rakshasa/rtorrent && \
    git clone https://github.com/rakshasa/libtorrent && \
    git clone https://github.com/mirror/xmlrpc-c.git && \
    cd /libtorrent && ./autogen.sh && ./configure && make -j 6 && make install && \
    cd /xmlrpc-c/stable && ./configure && make -j 6 && make install && \
    cd /rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c && make -j 6 && make install && \
    strip -s /usr/local/bin/rtorrent && \
    strip -s /usr/local/bin/mediainfo && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* /tmp/*

# RUN apk --no-cache add yarn nodejs-npm
# RUN cd /flood && yarn install

VOLUME [ "/data", "/config" ]
COPY root/ /
#LABEL org.label-schema.vcs-ref=$VCS_REF org.label-schema.build-date=$BUILD_DATE

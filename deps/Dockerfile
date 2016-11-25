FROM python:2-alpine
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV WKHTMLTOX_VERSION="0.12.4" \
    ALPINE_VERSION="3.4.6"

#Use dash instead busybox
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update --no-cache tini dash@testing && \
    cp /bin/sh /sh && cp /usr/bin/dash /bin/sh && mkdir -p /app /etc/skel

COPY localtime /etc/localtime

COPY wkhtmltopdf-install install-deps /usr/local/bin/

RUN apk add --no-cache -t .builddeps alpine-sdk perl mesa-dev libice-dev libsm-dev libx11-dev libxext-dev \
	libxrender-dev alsa-lib-dev openssl-dev fontconfig-dev freetype-dev \
	glib-dev libpng-dev zlib-dev  dbus-dev \
	gtk+-dev tiff-dev libmng-dev libxrandr-dev libxv-dev libxi-dev perl \
	gawk paxmark rsync freetds-dev hicolor-icon-theme mesa-gl \
    && /usr/local/bin/wkhtmltopdf-install \
    && apk del --no-cache .builddeps && rm -rf /tmp/*

RUN apk add --no-cache -t .rundeps nodejs-lts postgresql-client libpq \
    && npm install -g less less-plugin-clean-css && npm cache clean \
    && rm -rf /usr/lib/node_modules/npm /tmp/* /root/.cache/*


ENTRYPOINT ["/sbin/tini", "-g", "--"]

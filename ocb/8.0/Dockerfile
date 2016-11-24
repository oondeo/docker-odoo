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
    && rm -rf /usr/lib/node_modules/npm


# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8  \
     ODOO_VERSION="8.0" \
     XDG_DATA_HOME="/var/lib/odoo/.local/share" \
     ODOO_HOME="/opt/odoo" \
     ODOO_ADDONS_HOME="/opt/odoo_addons_src" \
     ODOO_SERVER="/opt/odoo/.env/bin/python odoo.py" \
     UNACCENT=True \
     PYTHON_BIN="/opt/odoo/.env/bin/python" \
     PIP_BIN="/opt/odoo/.env/bin/pip" \
     OCA_URL="https://github.com/OCA" \
     ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
     ODOO_MODULES="" \
     PYTHON_MODULES="unicodecsv pyinotify openupgradelib ofxparse" \
     BUILD_PACKAGES=" \
        alpine-sdk postgresql-dev libxml2-dev libffi-dev freetype-dev jpeg-dev \
        libwebp-dev tiff-dev libpng-dev lcms2-dev openjpeg-dev zlib-dev openldap-dev \
        libxslt-dev \
        bash \
        git \
		bzip2-dev \
		gcc \
		gdbm-dev \
		libc-dev \
		linux-headers \
		make \
		ncurses-dev \
		openssl \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		zlib-dev \
        " \
    RUN_PACKAGES=""


# Create odoo user with $HOME to store some data
RUN adduser -D -u 1000 odoo && mkdir -p /mnt/extra-addons /mnt/extra-addons-src /etc/odoo $ODOO_HOME/addons /var/log/odoo /var/lib/odoo/src \
        $XDG_DATA_HOME/addons $XDG_DATA_HOME/.local/share/Odoo/addons /home/odoo/.local/share /home/odoo/.cache \
        /home/odoo/.local  /etc/skel /opt/odoo/addons /opt/odoo_addons_src /var/log/odoo \
        && chown -R odoo /home/odoo /var/lib/odoo /var/log/odoo

COPY getbuildpkgs odoo-install /usr/local/bin/

RUN apk add -t .rundeps $RUN_PACKAGES \
    && apk add --no-cache -t .builddeps $BUILD_PACKAGES \
    && pip install virtualenv && virtualenv --system-site-packages /opt/odoo/.env \
    && $PIP_BIN install $PYTHON_MODULES \
    && /usr/local/bin/odoo-install \
    && rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
    && apk del --no-cache .builddeps && rm -rf /tmp/*  ~/.cache

COPY start.sh debug launch pot unittest  /usr/local/bin/

VOLUME ["/var/lib/odoo", "/mnt/odoo","/mnt/extra-addons", "/mnt/extra-addons-src", "/var/log/odoo" , "/etc/odoo","/etc/skel"]

WORKDIR /var/lib/odoo

ENTRYPOINT ["/sbin/tini", "-g", "--"]

CMD ["launch"]

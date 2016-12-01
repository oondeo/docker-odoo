FROM oondeo/alpine
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV WKHTMLTOX_VERSION="0.12.4" \
    ALPINE_VERSION="3.4.6"

COPY build-scripts/* /usr/local/bin/

COPY wkhtmltopdf /usr/bin

ENV VENV_HOME="/opt/odoo/.env"
ENV PYTHON_BIN="/usr/bin/python"
ENV ODOO_VERSION="8.0"
# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8  \
     XDG_DATA_HOME="/var/lib/odoo/.local/share" \
     ODOO_HOME="/opt/odoo" \
     ODOO_ADDONS_HOME="/opt/odoo_addons_src" \
     ODOO_SERVER="$PYTHON_BIN odoo.pyc" \
     ODOO_MODULE_FILE="__init__.pyc" \
     UNACCENT=True \
     PYTHONDONTWRITEBYTECODE=True \
     PIP_BIN="/usr/bin/pip" \
     OCA_URL="https://github.com/OCA" \
     ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
     ODOO_TARBALL_DIR="OCB-$ODOO_VERSION" \
     ODOO_MODULES="" \
     PYTHON_MODULES="unicodecsv ofxparse" \
     DEVELOP="no" \
     BUILD_PACKAGES=" \
        build-base postgresql-dev libxml2-dev libffi-dev freetype-dev jpeg-dev \
        libwebp-dev tiff-dev libpng-dev lcms2-dev openjpeg-dev zlib-dev openldap-dev \
        libxslt-dev \
        bash \
        git \
        curl \
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
        nodejs-lts \
        py-pip \
        py-virtualenv \
        python-dev \
        ruby \
        ruby-dev \
        " \
    RUN_PACKAGES="libjpeg \
        fontconfig \
        freetype \
        libpng \
        libx11 \
        libxrender \
        libxext \
        zlib \
        python \
        py-setuptools \
        libstdc++ \
        libgcc \
        postgresql-client \
        libpq"


# Create odoo user with $HOME to store some data
RUN adduser -D -u 1000 odoo && mkdir -p /mnt/extra-addons /mnt/extra-addons-src /etc/odoo $ODOO_HOME/addons /var/log/odoo /var/lib/odoo/src \
        $XDG_DATA_HOME/addons $XDG_DATA_HOME/.local/share/Odoo/addons /home/odoo/.local/share /home/odoo/.cache \
        /home/odoo/.local  /etc/skel /opt/odoo /opt/odoo_addons_src /var/log/odoo \
        && chown -R odoo /home/odoo /var/lib/odoo /var/log/odoo

COPY scripts/* /usr/local/bin/

RUN chmod +x /usr/local/bin/* \
    && apk add --no-cache -t .rundeps $RUN_PACKAGES \
    && cd /usr/lib/python2.7/site-packages && python -m compileall . \
    && find /usr/lib/python2.7 -name "*.py" -exec rm -f {} \; \
    && find /usr/lib/python2.7 -name "*.pyo" -exec rm -f {} \;


ONBUILD COPY . /app
ONBUILD RUN  build-install \
    && chmod +x /app/build.sh && /app/build.sh  \
    && rm -rf /tmp/*  ~/.cache

VOLUME ["/var/lib/odoo", "/mnt/odoo","/mnt/extra-addons", "/mnt/extra-addons-src", "/var/log/odoo" , "/etc/odoo","/etc/skel"]

WORKDIR /opt/odoo

CMD ["/usr/local/bin/launch"]

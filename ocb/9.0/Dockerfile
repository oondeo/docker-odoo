FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV ODOO_WORKKERS=0 \
    ADMIN_PASSWORD=admin \
    ODOO_SERVER=odoo.py \
    UNACCENT=True \
    ODOO_VERSION=9.0 \
    ODOO_RELEASE=20160324 \
    WKHTMLTOPDF_VERSION=0.12.1.2 \
    REMOTE_MODULE_INSTALLER_VERSION=0.1 \

# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \

    BUILD_PACKAGES="wget \
        bzr \
        git \
        mercurial \
        openssh-client \
        subversion \
        autoconf \
        automake \
        bzip2 zip unzip \
        g++ \
        gcc \
        imagemagick \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libevent-dev \
        libffi-dev \
        libgeoip-dev \
        libglib2.0-dev \
        libjpeg-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmysqlclient-dev \
        libncurses-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        patch \
        xz-utils \
        zlib1g-dev \
        npm \
        fontconig \
        libfreetype6-dev \
        node-less \
        node-clean-css \
        python-pip \
        python-dev \
        libtool \
        python-support \
        libldap2-dev \
        libsasl2-dev \
        " \
    RUN_PACKAGES="ca-certificates file curl \
            adduser \
            python \
            python-renderpm \
            antiword \
            graphviz \
            ghostscript \
            poppler-utils \
            libpq5 \
        " \

    ODOO_MODULES_URLS=""

ADD debug launch pot unittest getbuildpkgs /usr/local/bin/

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends $RUN_PACKAGES \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-jessie-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf wkhtmltox.deb /var/lib/apt/*

# Install Odoo
RUN apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp/ && \
    curl --location --remote-name \
        https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip && \
    unzip -q ./$ODOO_VERSION.zip -d ./ && \
    pip install reportlab pyinotify gevent && \
    pip install ./OCB-$ODOO_VERSION/ && \
    mv ./OCB-$ODOO_VERSION/addons/* \
        /usr/local/lib/python2.7/dist-packages/openerp/addons/ && \
# Create odoo user with $HOME to store some data
    useradd --create-home odoo && \
#----------Development---------------------------------------------
    curl -SL -o oca_install.zip https://github.com/amon-ra/oca_install/archive/$REMOTE_MODULE_INSTALLER_VERSION.zip && \
    unzip oca_install.zip && \
    mv oca_install-$REMOTE_MODULE_INSTALLER_VERSION/oca_install /usr/local/lib/python2.7/dist-packages/openerp/addons/ && \
#Install wdb for development
    pip install wdb && \
# Add PhantomJS for headless ECMAScript tests
    npm install --global phantomjs && \
    chown -R odoo /usr/local/lib/python2.7/dist-packages && \
#------------------------------------------------------------------
#----------Production----------------------------------------------
#apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    rm -rf /var/lib/apt/* && \
    rm -Rf ./* && \
# Create path for extra addons
    mkdir -p /mnt/extra-addons /etc/odoo && \
    chown -R odoo /mnt/extra-addons /var/{lib,log}/odoo /home/odoo && \
    cd /



VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8071 1984

CMD ["launch"]
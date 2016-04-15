FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV ODOO_WORKKERS=0 \
    ODOO_SERVER="python odoo.py" \
    UNACCENT=True \
    ODOO_VERSION=9.0 \
    ODOO_RELEASE=20160324 \
    NODE_VERSION=5.10.1 \
    WKHTMLTOPDF_VERSION=0.12.1.2 \
    PHANTOMJS_VERSION=2.1.1 \
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
        fontconfig \
        libfreetype6-dev \
        npm \
        node \
        nodejs \
        node-less \
        node-clean-css \
        python-pip \
        python-dev \
        libtool \
        python-support \
        libldap2-dev \
        libsasl2-dev \
        ruby-sass \
        ruby-compass \
        paxctl \
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
RUN  mkdir -p /mnt/extra-addons /etc/odoo /opt/odoo/addons /var/log/odoo /var/lib/odoo /home/odoo && \
    apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/lib/nodejs \
    curl --location --remote-name \
        https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip && \
    unzip -q ./$ODOO_VERSION.zip -d ./ && \
    cp -a OCB-$ODOO_VERSION/* /opt/odoo && \
    pip install  reportlab pyinotify gevent && \
    cd /opt/odoo && pip install -r requirements.txt && \
    python setup.py develop && \
# Create odoo user with $HOME to store some data
    useradd --create-home odoo && \
#----------Development---------------------------------------------
    curl -SL -o oca_install.zip https://github.com/amon-ra/oca_install/archive/$REMOTE_MODULE_INSTALLER_VERSION.zip && \
    unzip oca_install.zip && \
    mv oca_install-$REMOTE_MODULE_INSTALLER_VERSION/oca_install /opt/odoo/addons/ && \
#Install wdb for development
    pip install wdb && \
# Add PhantomJS for headless ECMAScript tests
    curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
    chown -R odoo /usr/local/lib/python2.7 /mnt/extra-addons /opt/odoo && \
#------------------------------------------------------------------
#----------Production----------------------------------------------
#apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    rm -rf /var/lib/apt/* && \
    rm -Rf /tmp/* && \
# Create path for extra addons
    chown -R odoo /var/log/odoo /var/lib/odoo /home/odoo && \
    cd /



VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8071 1984

CMD ["launch"]

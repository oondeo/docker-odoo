FROM oondeo/odoo:deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV PHANTOMJS_VERSION=2.1.1 \
    REMOTE_MODULE_INSTALLER_VERSION=0.1 \
    ODOO_VERSION=8.0 \
    ODOO_MODULES_URLS="" \
# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \
    PYTHON_BIN="/opt/odoo/.env/bin/python" \
    ODOO_SERVER="/opt/odoo/.env/bin/python /opt/odoo/odoo.py" \
    PYTHON_MODULES="unicodecsv pyinotify openupgradelib \
    ofxparse flanker odoo_gateway" \
    BUILD_PACKAGES="bzr \
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
        libxslt1-dev \
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
        virtualenv \
        libtool \
        python-support \
        libldap2-dev \
        libsasl2-dev \
        ruby-sass \
        ruby-compass \
        "

# Install Odoo build requirements
RUN apt-get update && apt-get install -y --no-install-recommends $BUILD_PACKAGES && \
    rm -f /var/log/apt/* && rm -f /var/log/* && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
    virtualenv --system-site-packages /opt/odoo/.env && \
    source /opt/odoo/.env/bin/activate && \
    pip install $PYTHON_MODULES && \
#----------Development---------------------------------------------
    curl -SL -o oca_install.zip https://github.com/amon-ra/oca_install/archive/$REMOTE_MODULE_INSTALLER_VERSION.zip && \
    unzip oca_install.zip && \
    mkdir -p $XDG_DATA_HOME/.local/share/Odoo/addons/$ODOO_VERSION && \
    mv oca_install-$REMOTE_MODULE_INSTALLER_VERSION/oca_install $XDG_DATA_HOME/.local/share/Odoo/addons/$ODOO_VERSION/ && \
#Install wdb for development
    pip install wdb && \
# Add PhantomJS for headless ECMAScript tests
    curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
    chown -R odoo /usr/local/lib/python2.7 /mnt/extra-addons /opt/odoo && \
    rm -rf /var/lib/apt/* && \
    rm -Rf /tmp/* && \
# Create path for extra addons
    chown -R odoo /var/log/odoo /var/lib/odoo /home/odoo && \
# Install odoo script
    /usr/local/bin/odoo_install

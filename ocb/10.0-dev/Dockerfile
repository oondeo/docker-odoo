FROM oondeo/odoo-deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV PHANTOMJS_VERSION=2.1.1 \
    ODOO_VERSION=10.0

ENV ODOO_MODULES=""
# Variables used by the WDB debugger, in case you link a WDB container
ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \
    PIP_BIN="/opt/odoo/.env/bin/pip" \
    PYTHON_BIN="/opt/odoo/.env/bin/python" \
    ODOO_SERVER="/opt/odoo/.env/bin/python /opt/odoo/odoo-bin" \
    OCA_URL="https://github.com/OCA" \
    ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip"

ENV PYTHON_MODULES="unicodecsv pyinotify openupgradelib \
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
        libtool \
        python-support \
        libldap2-dev \
        libsasl2-dev \
        ruby-sass \
        ruby-compass \
        "

# Install Odoo build requirements
RUN apt-get update && apt-get install -y --no-install-recommends $BUILD_PACKAGES && \
    rm -f /var/log/apt/* || true && rm -f /var/log/* || true && rm -rf /var/lib/apt/* || true && \
    pip install --upgrade pip setuptools virtualenv && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
    virtualenv --system-site-packages /opt/odoo/.env && \
    $PIP_BIN install $PYTHON_MODULES && \
#----------Development---------------------------------------------
    mkdir -p $XDG_DATA_HOME/.local/share/Odoo/addons/$ODOO_VERSION && \
#Install wdb for development
    pip install wdb && \
# Add PhantomJS for headless ECMAScript tests
    curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
#cleanup
    rm -rf /tmp/* /root/.cache /var/lib/apt || true

# Install odoo script
RUN /usr/local/bin/odoo-install
#fix permisions
RUN chown -R odoo /usr/local/lib/python2.7 /var/log/odoo /var/lib/odoo /home/odoo

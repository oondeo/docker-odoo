FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV DEBIAN_FRONTEND=noninteractive LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8 XDG_DATA_HOME="/home/odoo/.local/share" \
    ODOO_SERVER="python odoo.py" \
    UNACCENT=True \
    NODE_VERSION=5.10.1 \
    WKHTMLTOPDF_VERSION=0.12.1.2 \
    PHANTOMJS_VERSION=2.1.1 \
    REMOTE_MODULE_INSTALLER_VERSION=0.1 \

# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \

    BUILD_PACKAGES="curl \
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
    RUN_PACKAGES="locales ca-certificates file 
            adduser \
	        locales \
            python \
            python-renderpm \
            antiword \
            graphviz \
            ghostscript \
            poppler-utils \
	        xdg-user-dirs \
            libpq5 \
            postgresql-client \
        " \
    PYTHON_MODULES="unicodecsv pyinotify openupgradelib ofxparse" \
    ODOO_MODULES_URLS=""

ADD debug launch pot unittest getbuildpkgs /usr/local/bin/

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends $RUN_PACKAGES \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-jessie-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf wkhtmltox.deb /var/lib/apt/* \
        && locale-gen $LANG && \
        mkdir -p /mnt/extra-addons /etc/odoo /opt/odoo/addons /var/log/odoo /var/lib/odoo /home/odoo && \
        # Create odoo user with $HOME to store some data
        useradd --create-home odoo        




VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/var/log/odoo"]

WORKDIR /opt/odoo
# Expose Odoo services
EXPOSE 8069 8071 1984

CMD ["launch"]

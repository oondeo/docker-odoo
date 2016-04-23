FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV DEBIAN_FRONTEND=noninteractive LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8 XDG_DATA_HOME="/var/lib/odoo" \
    ODOO_SERVER="python odoo.py" \
    UNACCENT=True \
    NODE_VERSION=5.10.1 \
    WKHTMLTOPDF_VERSION=0.12.1.2 \

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
    RUN_PACKAGES="locales ca-certificates file \
            adduser \
	        locales \
            python \
            python-renderpm \
            antiword \
            graphviz \
            ghostscript \
            poppler-utils \
            libpq5 \
            postgresql-client \
            docutils-common \
            fontconfig  \
            fonts-liberation  \
            graphviz  \
            javascript-common \
            libgdbm3  \
            libgvc6  \
            libjs-jquery  \
            libpango-1.0-0 \
            libpangocairo-1.0-0  \
            libpangoft2-1.0-0  \
            libpaper-utils  \
            libpython2.7  \
            libtidy-0.99-0  \
            libwebp5  \
            libwebpdemux1  \
            libwebpmux1  \
            libxslt1.1 \
            libyaml-0-2  \
            rename  \
            sgml-base  \
            xml-core  \           
            " \
    PYTHON_MODULES="unicodecsv pyinotify openupgradelib ofxparse" \
    ODOO_MODULES_URLS=""

ADD debug launch pot unittest getbuildpkgs /usr/local/bin/

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update && apt-get install -y --no-install-recommends curl \
        && apt-get install -y --no-install-recommends $RUN_PACKAGES \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-jessie-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && echo $LANG UTF-8 >> /etc/locale.gen \
        && locale-gen \
        && apt-get --auto-remove -y purge  curl && rm -rf wkhtmltox.deb /var/lib/apt/* \
        # Create odoo user with $HOME to store some data
        && useradd --create-home odoo  \
        && mkdir -p /mnt/extra-addons /etc/odoo/addons /etc/odoo/src /opt/odoo/addons /var/log/odoo /var/lib/odoo/addons /home/odoo/.local/share /etc/skel \
        && chown -R odoo /home/odoo/.local/share /var/lib/odoo
     




VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/var/log/odoo" , "/etc/odoo","/etc/skel"]

WORKDIR /opt/odoo
# Expose Odoo services
EXPOSE 8069 8071 1984

CMD ["launch"]

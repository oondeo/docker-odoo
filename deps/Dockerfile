FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>


# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV DEBIAN_FRONTEND=noninteractive LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8  \
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
        " \
    RUN_PACKAGES="locales ca-certificates file \
            libdap2 \
            dapl2-utils \
            libfreetype6 \
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
            libsasl2-2 \
            libsasl2-modules \
            libsasl2-modules-ldap \
            " 


# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update && apt-get install -y --no-install-recommends curl paxctl \
        && apt-get install -y --no-install-recommends $RUN_PACKAGES \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && echo $LANG UTF-8 >> /etc/locale.gen \
        && locale-gen \
        # Create odoo user with $HOME to store some data
        && mkdir -p /mnt/extra-addons /etc/odoo/addons /etc/odoo/src /opt/odoo/addons /var/log/odoo /var/lib/odoo/src \
        /var/lib/odoo/addons /var/lib/odoo/.local/share/Odoo/addons /home/odoo/.local/share /home/odoo/.cache \
        /home/odoo/.local  /etc/skel \
        && useradd -b /var/lib/odoo odoo  \
        && chown -R odoo /home/odoo /var/lib/odoo 
     




VOLUME ["/opt/odoo","/var/lib/odoo", "/mnt/extra-addons", "/var/log/odoo" , "/etc/odoo","/etc/skel"]

WORKDIR /opt/odoo


ENV WKHTMLTOPDF_VERSION=0.12.1.2 
RUN     curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-jessie-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get update && apt-get -y install -f --no-install-recommends  \
        && paxctl -Cm /usr/local/bin/wkhtmltopdf \
        && paxctl -Cm /usr/local/bin/wkhtmltoimage \
        && rm -rf wkhtmltox.deb /var/lib/apt/* 
         
# Add Tini
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN curl -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && chmod +x /tini

ADD debug launch pot unittest getbuildpkgs /usr/local/bin/

ENTRYPOINT ["/tini", "--"]

RUN ["launch"]

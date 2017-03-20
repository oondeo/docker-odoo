FROM debian:jessie
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>


ENV DEBIAN_FRONTEND=noninteractive
ENV TINI_VERSION=v0.13.0
RUN cp /bin/sh /sh && apt-get update && apt-get install -y --no-install-recommends curl \
    && curl -o /sbin/tini -SLk https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && chmod +x /sbin/tini && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/* /var/tmp/* /tmp/* /var/log/* || true

ENTRYPOINT ["/sbin/tini", "-g" ,"--", "/usr/local/bin/start.sh"]

ENV WKHTMLTOPDF_VERSION=0.12.1.2
RUN     apt-get update && apt-get install -y --no-install-recommends curl paxctl \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-jessie-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get update && apt-get -y install -f --no-install-recommends  \
        && paxctl -Cm /usr/local/bin/wkhtmltopdf \
        && rm /usr/local/bin/wkhtmltoimage \
        && apt-get purge -y --auto-remove curl paxctl \
        && rm -rf wkhtmltox.deb /var/lib/apt/* /var/tmp/* /tmp/* /var/log/* /usr/share/doc/* || true


ENV XDG_DATA_HOME="/var/lib/odoo/.local/share" \
     ODOO_HOME="/opt/odoo" \
     ODOO_ADDONS_HOME="/opt/odoo_addons_src"

# Create odoo user with $HOME to store some data
RUN  useradd -b /var/lib odoo  && mkdir -p /mnt/extra-addons /mnt/extra-addons-src /etc/odoo $ODOO_ADDONS_HOME /var/log/odoo /var/lib/odoo/src \
        $XDG_DATA_HOME/addons $XDG_DATA_HOME/.local/share/Odoo/addons /home/odoo/.local/share /home/odoo/.cache \
        /home/odoo/.local  /etc/skel /opt/odoo /opt/odoo_addons_src /var/log/odoo \
        && chown -R odoo /home/odoo /var/lib/odoo /var/log/odoo

ENV VENV_HOME="/opt/odoo/.env"
ENV PIP_DIR="/usr/local/lib/python2.7/dist-packages" \
    PYTHON_DIR="/usr/lib/python2.7"
ENV PYTHON_BIN="python"
ENV ODOO_VERSION="8.0"
# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8  \
     ODOO_SERVER="$PYTHON_BIN odoo.pyc" \
     ODOO_MODULE_FILE="__init__.pyc" \
     UNACCENT=True \
     PYTHONDONTWRITEBYTECODE=True \
     PIP_BIN="pip" \
     OCA_URL="https://github.com/OCA" \
     ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
     ODOO_TARBALL_DIR="OCB-$ODOO_VERSION" \
     ODOO_MODULES="" \
     PYTHON_MODULES="unicodecsv ofxparse" \
     DEVELOP="no" \
     BUILD_PACKAGES="git \
         curl \
         paxctl \
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
            libldap-2.4 \
            libfreetype6 \
            locales \
            gsfonts \
            antiword \
            graphviz \
            poppler-utils \
            libpq5 \
            postgresql-client \
            fontconfig  \
            fonts-liberation  \
            graphviz  \
            libgdbm3  \
            libgvc6  \
            libjs-jquery  \
            libpango-1.0-0 \
            libpangocairo-1.0-0  \
            libpangoft2-1.0-0  \
            libpaper-utils  \
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
            python \
            python-renderpm \
            python-setuptools \
            zip \
            "

RUN apt-get update && apt-get install -y --no-install-recommends $RUN_PACKAGES \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && echo $LANG UTF-8 >> /etc/locale.gen \
        && locale-gen \
        && cd $PYTHON_DIR && python -m compileall . \
        && find $PYTHON_DIR -name "*.py" -and -not -name "__*" -and -not -name "compileall.py" -exec rm -f {} \; \
        && rm -rf /var/lib/apt/* /var/tmp/* /tmp/* /var/log/* ~/.cache /usr/share/doc/* || true

COPY scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*


ONBUILD COPY . /app
ONBUILD RUN  build-install \
    && chmod +x /app/build.sh && /app/build.sh  \
    && rm -rf /tmp/*  ~/.cache  /var/lib/apt/* /var/tmp/* /tmp/* /var/log/* ~/.cache /usr/share/doc/* || true

VOLUME ["/var/lib/odoo", "/mnt/odoo","/mnt/extra-addons", "/mnt/extra-addons-src", "/var/log/odoo" , "/etc/odoo","/etc/skel"]

WORKDIR /opt/odoo

CMD ["/usr/local/bin/launch"]

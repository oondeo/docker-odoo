FROM yajo/centos-epel

MAINTAINER yajo@openaliasbox.org

# Launcher will patch configuration on first run and launch Odoo
CMD launch

# Odoo ports for web and chat
EXPOSE 8069 8072

# Variables used by the launch scripts
ENV ADMIN_PASSWORD=admin \
    ODOO_SERVER=odoo.py \
    UNACCENT=True \
    ODOO_VERSION=9.0 \

# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

# Runtime dependencies
RUN yum -y install postgresql python-pip \

# Cannot use CentOS version of wkhtmltopdf because it's not patched to work
# without an X server, so let's install the official upstream RPM instead
    http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm && \

# Install OCB and debugger. Workaround https://github.com/OCA/OCB/issues/334
    yum -y install gcc libxml2-devel libxslt-devel openldap-devel \
        postgresql-devel python-devel unzip && \
    pip install --no-deps --download /tmp/ \
        https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip && \
    unzip -q /tmp/$ODOO_VERSION.zip -d /tmp/ && \
    pip install wdb /tmp/OCB-$ODOO_VERSION/ && \
    mv /tmp/OCB-$ODOO_VERSION/addons/* \
        /usr/lib/python2.7/site-packages/openerp/addons/ && \
    rm -Rf /tmp/* && \
    yum -y history undo last && \

# Add PhantomJS for headless ECMAScript tests
    yum -y install freetype fontconfig bzip2 npm && \
    npm install --global phantomjs && \

# Add locales
    yum -y reinstall glibc-common && \

# Clean garbage
    yum clean all && \

# Create path for extra addons
    mkdir --parents /opt/odoo/extra-addons && \

# Create odoo user with $HOME to store some data
    useradd --create-home odoo && \

# Configure launchers
    touch /firstrun
ADD debug launch pot unittest /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

# Folders modified at runtime by Odoo
VOLUME ["/home/odoo", "/var/lib/odoo", "/var/log/odoo"]

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

# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

# Install Odoo and psql (to install unaccent automatically)
RUN curl --output /etc/yum.repos.d/odoo.repo \
    http://nightly.odoo.com/8.0/nightly/rpm/odoo.repo && \
    yum -y install odoo postgresql && \

# Extra dependencies
# TODO Remove after fixing https://github.com/odoo/odoo/issues/4021
    yum -y install python-gevent && \

# Cannot use CentOS version of wkhtmltopdf because it's not patched to work
# without an X server, so let's install the official upstream RPM instead
    yum -y install http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm && \

# Add a debugger
    yum -y install gcc python-devel python-pip && \
    pip install wdb && \
    yum -y history undo last && \

# Add locales
    yum -y reinstall glibc-common && \

    yum clean all && \

# Create path for extra addons
    mkdir --parents /opt/odoo/extra-addons && \

# Create odoo $HOME to store some data
    mkdir /home/odoo && \
    chown odoo:odoo /home/odoo && \

# Configure launchers
    touch /firstrun
ADD debug launch pot unittest /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

# Folders modified at runtime by Odoo
VOLUME ["/home/odoo", "/var/lib/odoo", "/var/log/odoo"]

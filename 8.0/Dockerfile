FROM yajo/centos-epel

MAINTAINER yajo@openaliasbox.org

# Install Odoo and psql (to install unaccent automatically)
RUN curl --output /etc/yum.repos.d/odoo.repo \
    http://nightly.odoo.com/8.0/nightly/rpm/odoo.repo
RUN yum --assumeyes install odoo postgresql

# Extra dependencies
# TODO Remove after fixing https://github.com/odoo/odoo/issues/4021
RUN yum --assumeyes install python-gevent

# Cannot use CentOS version of wkhtmltopdf because it's not patched to work
# without an X server, so let's install the official upstream RPM instead
RUN yum --assumeyes install http://softlayer-ams.dl.sourceforge.net/project/wkhtmltopdf/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm

# Add a debugger
RUN yum --assumeyes install gcc python-devel python-pip
RUN pip install wdb
RUN yum --assumeyes history undo last
ENV WDB_NO_BROWSER_AUTO_OPEN True
ENV WDB_SOCKET_SERVER wdb
ENV WDB_WEB_PORT 1984
ENV WDB_WEB_SERVER localhost

# Add locales
RUN yum --assumeyes reinstall glibc

RUN yum clean all

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Folders modified at runtime by Odoo
VOLUME ["/var/lib/odoo", "/var/log/odoo"]

# Odoo ports for web and chat
EXPOSE 8069 8072

# Configure launchers
RUN touch /firstrun
ENV ADMIN_PASSWORD admin
ENV ODOO_SERVER odoo.py
ENV UNACCENT True
ADD debug launch pot unittest /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

# Launcher will patch configuration on first run and launch Odoo
CMD launch

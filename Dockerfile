FROM yajo/centos-epel

MAINTAINER yajo@openaliasbox.org

# Install Odoo
RUN curl --output /etc/yum.repos.d/odoo.repo \
    http://nightly.odoo.com/8.0/nightly/rpm/odoo.repo
RUN yum --assumeyes install odoo

# Extra dependencies
# TODO Remove after fixing https://github.com/odoo/odoo/issues/4021
RUN yum --assumeyes install python-gevent wkhtmltopdf

# Add a debugger
RUN yum --assumeyes install gcc python-devel python-pip
RUN pip install wdb.server
RUN yum --assumeyes history undo last
ENV WDB_WEB_SERVER localhost
ENV WDB_WEB_PORT 1984
EXPOSE 1984

RUN yum clean all

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Folders modified at runtime by Odoo
VOLUME ["/var/log/odoo", "/var/log/openerp", "/var/lib/odoo"]

# Odoo ports for web and chat
EXPOSE 8069 8072

# Configure launchers
RUN touch /firstrun
ENV ADMIN_PASSWD admin
ENV ODOO_SERVER odoo.py
ENV UNACCENT True
ADD debug launch pot unittest /usr/local/bin/

# Launcher will patch configuration on first run and launch Odoo
CMD launch

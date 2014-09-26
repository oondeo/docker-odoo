FROM centos

MAINTAINER yajo@openaliasbox.org

# Add EPEL
RUN yum --assumeyes install \
    http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm

# Update everything
RUN yum --assumeyes update

# Install Odoo and dependencies
RUN yum --assumeyes install \
    cyrus-sasl-devel \
    gcc \
    heimdal-devel \
    libpng12 \
    libpqxx-devel \
    libxml2-devel \
    libxslt-devel \
    openldap-devel \
    openssl-devel \
    postgresql \
    python-devel \
    python-pip \
    http://netcologne.dl.sourceforge.net/project/wkhtmltopdf/0.12.1/wkhtmltox-0.12.1_linux-centos6-amd64.rpm
RUN pip install https://github.com/odoo/odoo/archive/8.0.zip#egg=Odoo

# I need a debugger
RUN pip install pudb
ADD pudb.cfg /home/odoo/.config/pudb/
RUN chown -R odoo:odoo /home/odoo

# Remove unneeded dependencies
RUN yum --assumeyes remove '*-devel'

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Used volumes
VOLUME ["/etc/openerp/", "/var/log/openerp", "/opt/odoo/extra-addons"]

# Odoo ports for web and chat
EXPOSE 8069 8072

# Configure launcher
RUN touch /firstrun
RUN useradd odoo
ENV ADMIN_PASSWD admin
ENV ODOO_SERVER openerp-server
ADD launch /usr/local/bin/
ADD pot /usr/local/bin/
ADD unittest /usr/local/bin/
ADD variables /usr/local/bin/

# Launcher will patch configuration on first run and launch Odoo
CMD launch

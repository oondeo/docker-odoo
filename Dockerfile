FROM centos

MAINTAINER yajo@openaliasbox.org

# Add EPEL
RUN yum --assumeyes install \
    http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm

# Install Odoo and dependencies
RUN yum --assumeyes install \
    gcc \
    git \
    postgresql \
    python-pip \
    http://netcologne.dl.sourceforge.net/project/wkhtmltopdf/0.12.1/wkhtmltox-0.12.1_linux-centos6-amd64.rpm
RUN pip install git+https://github.com/odoo/odoo.git@8.0#egg=Odoo

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Used volumes
VOLUME ["/etc/openerp/", "/var/log/openerp", "/opt/odoo/extra-addons"]

# Odoo ports for web and chat
EXPOSE 8069 8072

# Configure launcher
RUN touch /firstrun
ENV ADMIN_PASSWD admin
ENV ODOO_SERVER openerp-server
ADD launcher.sh /opt/odoo/

# Launcher will patch configuration on first run and launch Odoo
CMD /opt/odoo/launcher.sh

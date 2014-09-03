FROM centos

MAINTAINER yajo@openaliasbox.org

# Add EPEL
RUN yum --assumeyes install \
    http://ftp.rediris.es/mirror/fedora-epel/7/x86_64/e/epel-release-7-1.noarch.rpm

# Install Odoo
RUN yum --assumeyes install \
    http://nightly.openerp.com/8.0/nightly/rpm/odoo_8.0rc1-latest.noarch.rpm

# Install Pychart from Fedora, because it is unavailable for CentOS 7 right now
RUN yum --assumeyes install \
    http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Everything/x86_64/os/Packages/p/pychart-1.39-16.fc20.noarch.rpm

# Additional dependencies
RUN yum --assumeyes install \
    python-pip \
    python-gevent

RUN pip install psycogreen

# PYTHONPATH needs to be patched
ENV PYTHONPATH PYTHONPATH=$(python -c "import sys; print ':'.join(x for x in sys.path if x)"):/usr/local/lib/python2.7/dist-packages/

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Used volumes
VOLUME ["/etc/openerp/", "/var/log/openerp", "/opt/odoo/extra-addons"]

# Load configuration and launcher
ADD openerp-server.conf /etc/openerp/
ADD launcher.sh /opt/odoo/

# Odoo ports for web and chat
EXPOSE 8069 8072

# Odoo command ready to link with database image nornagon/postgres
CMD /opt/odoo/launcher.sh

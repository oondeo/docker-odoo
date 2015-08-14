# Based on the same as other containers to reuse downloaded layers
FROM yajo/centos-epel

# Volumes used by Odoo; permissions are set when executing `launch`
VOLUME ["/home/odoo", "/var/lib/odoo", "/var/log/odoo"]

# This container will be stopped, since we only need it to hold volume data
CMD ["/usr/bin/true"]

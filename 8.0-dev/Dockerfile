FROM oondeo/odoo:deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV ODOO_VERSION=8.0 PHANTOMJS_VERSION=2.1.1 \
    REMOTE_MODULE_INSTALLER_VERSION=0.1 \
    ODOO_ADDONS_PATH="/opt/odoo/openerp/addons /opt/odoo/addons \
      /usr/local/lib/python2.7/dist-packages/openerp/addons /etc/odoo/addons \
      /etc/odoo/src/* /mnt/extra-addons /var/lib/odoo/addons /var/lib/odoo/src/* \
      /var/lib/odoo/addons/$ODOO_VERSION" \
    PYTHON_MODULES="unicodecsv pyinotify openupgradelib \
      ofxparse flanker pylint-odoo odoo_gateway pep8 wdb"
# Variables used by the WDB debugger, in case you link a WDB container
    WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

# Install Odoo build requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
#----------Development---------------------------------------------
    curl -SL -o oca_install.zip https://github.com/amon-ra/oca_install/archive/$REMOTE_MODULE_INSTALLER_VERSION.zip && \
    unzip oca_install.zip && \
    mv oca_install-$REMOTE_MODULE_INSTALLER_VERSION/oca_install /usr/local/lib/python2.7/dist-packages/openerp/addons && \
# Add PhantomJS for headless ECMAScript tests
    curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
    chown -R odoo /usr/local/lib/python2.7 /mnt/extra-addons /opt/odoo /var/lib/odoo /etc/odoo && \
#------------------------------------------------------------------
#----------Production----------------------------------------------
#apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    rm -rf /var/lib/apt/* && \
    rm -Rf /tmp/* && \
# Create path for extra addons
    chown -R odoo /var/log/odoo /var/lib/odoo /home/odoo

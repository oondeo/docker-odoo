FROM oondeo/odoo:8

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

# Install Odoo build requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
#----------Development---------------------------------------------
    curl -SL -o oca_install.zip https://github.com/amon-ra/oca_install/archive/$REMOTE_MODULE_INSTALLER_VERSION.zip && \
    unzip oca_install.zip && \
    mv oca_install-$REMOTE_MODULE_INSTALLER_VERSION/oca_install /home/odoo/.local/share/Odoo/addons/$ODOO_VERSION/ && \
#Install wdb for development
    pip install wdb && \
# Add PhantomJS for headless ECMAScript tests
    curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
    chown -R odoo /usr/local/lib/python2.7 /mnt/extra-addons /opt/odoo && \
#------------------------------------------------------------------
#----------Production----------------------------------------------
#apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    rm -rf /var/lib/apt/* && \
    rm -Rf /tmp/* && \
# Create path for extra addons
    chown -R odoo /var/log/odoo /var/lib/odoo /home/odoo
FROM oondeo/odoo:deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV  ODOO_VERSION=8.0 

# Install Odoo
RUN  mkdir -p /mnt/extra-addons /etc/odoo /opt/odoo/addons /var/log/odoo /var/lib/odoo /home/odoo && \
    apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
    curl --location --remote-name \
        https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip && \
    unzip -q ./$ODOO_VERSION.zip -d ./ && \
    cp -a OCB-$ODOO_VERSION/* /opt/odoo && \
    pip install -r /opt/odoo/requirements.txt && \
    pip install  $PYTHON_MODULES && \
    cd /usr/local/lib/python2.7 && python -m compileall . && \
    cd /opt/odoo && \
    python -m compileall . && \    
    python setup.py develop && make && \
    cd /tmp && \
    echo es_ES.UTF-8 UTF-8 > /etc/locale.gen && locale-gen && \
# Create odoo user with $HOME to store some data
    useradd --create-home odoo && mkdir -p /home/odoo/.local/share/Odoo/addons/$ODOO_VERSION && \
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
    chown -R odoo /var/log/odoo /var/lib/odoo /home/odoo && \
    cd /



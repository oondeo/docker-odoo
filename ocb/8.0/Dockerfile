FROM oondeo/odoo:deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

#ENV PYTHON_MODULES="unicodecsv pyinotify openupgradelib ofxparse" 
ENV  ODOO_VERSION=8.0 \
     ODOO_MODULES_URLS=""


#COPY addons /etc/odoo/addons/

# Install Odoo
RUN  apt-get update && apt-get install -y --no-install-recommends \
    $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
    pip install --upgrade pip setuptools && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
    curl --location --remote-name \
        https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip && \
    unzip -q ./$ODOO_VERSION.zip -d ./ && \
    cp -a OCB-$ODOO_VERSION/* /opt/odoo && \
    pip install -r /opt/odoo/requirements.txt && \
    pip install  $PYTHON_MODULES && \
    cd /opt/odoo && \
    python setup.py develop && make && \
    python -m compileall . && \
    cd /usr/local/lib/python2.7 && python -m compileall . && \
    cd /tmp && \
#----------Production----------------------------------------------
#INSTALL ADDONS
#CLEAN
    apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    chown -R odoo /home/odoo /var/lib/odoo /var/log/odoo && \
    rm -rf /var/lib/apt/* && rm -Rf /tmp/* 


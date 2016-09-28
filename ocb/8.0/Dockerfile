FROM oondeo/odoo:deps

MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

#ENV PYTHON_MODULES="unicodecsv pyinotify openupgradelib ofxparse"
ENV  ODOO_VERSION=8.0

ENV  ODOO_MODULES="https://github.com/oondeo/git-install/archive/8.0.zip" \
    PIP_BIN="/opt/odoo/.env/bin/pip" \
    PYTHON_BIN="/opt/odoo/.env/bin/python" \
    ODOO_SERVER="/opt/odoo/.env/bin/python /opt/odoo/odoo.py" \
    OCA_URL="https://github.com/OCA" \
    ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip"


#COPY addons /etc/odoo/addons/

# Install Odoo
RUN apt-get update && apt-get install -y --no-install-recommends $BUILD_PACKAGES && \
    rm -f /var/log/apt/* || true && rm -f /var/log/* || true && rm -rf /var/lib/apt/* || true && \
    pip install --upgrade pip setuptools virtualenv && \
    cd /tmp && paxctl -Cm /usr/bin/nodejs && \
    virtualenv --system-site-packages /opt/odoo/.env && \
    $PIP_BIN install $PYTHON_MODULES && \
    mkdir -p $XDG_DATA_HOME/.local/share/Odoo/addons/$ODOO_VERSION && \
#----------Production----------------------------------------------
     /usr/local/bin/odoo-install
#INSTALL ADDONS
#CLEAN
    apt-get -y --auto-remove purge $(getbuildpkgs "$BUILD_PACKAGES" "$RUN_PACKAGES") && \
#-------------------------------------------------------------------
    chown -R odoo /home/odoo /var/lib/odoo /var/log/odoo && \
    rm -rf /var/lib/apt/*  /tmp/* /root/.cache \| true

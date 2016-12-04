#!/sh

set -e
export ODOO_VERSION="10.0"
export ODOO_MODULES="" \
  ODOO_SERVER="$PYTHON_BIN odoo-bin" \
  ODOO_MODULE_FILE="__manifest__.pyc" \
  ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
  ODOO_TARBALL_DIR="OCB-$ODOO_VERSION"

export > /etc/skel/initrc
/usr/local/bin/odoo-install
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
#fix pillow
CFLAGS="$CFLAGS -L/lib"
$PIP_BIN install -I --no-cache-dir Pillow
cd /opt
$PYTHON_BIN -m compileall .
cd /usr/lib/python2.7/site-packages && python -m compileall .
install-deps /opt /usr/lib/python2.7/site-packages
/usr/local/bin/clean.sh

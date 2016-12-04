#!/sh

set -e


/usr/local/bin/odoo-install
#fix pillow
CFLAGS="$CFLAGS -L/lib"
$PIP_BIN install -I --no-cache-dir Pillow
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
cd /opt
$PYTHON_BIN -m compileall .
cd /usr/lib/python2.7/site-packages && python -m compileall .
install-deps /opt /usr/lib/python2.7/site-packages
/usr/local/bin/clean.sh

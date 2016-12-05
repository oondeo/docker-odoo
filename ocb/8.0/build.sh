#!/sh

set -e


/usr/local/bin/odoo-install
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
cd /opt
$PYTHON_BIN -m compileall .
cd $PYTHON_DIR && python -m compileall .
/usr/local/bin/clean.sh

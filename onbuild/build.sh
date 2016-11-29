#!/sh

export ODOO_MODULES="https://github.com/OCA/l10n-spain/archive/8.0.zip"
set -e

/usr/local/bin/odoo-install
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
cd /opt
$PYTHON_BIN  -m compileall .
/usr/local/bin/clean.sh

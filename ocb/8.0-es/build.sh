#!/sh

set -e
export ODOO_MODULES="https://github.com/OCA/l10n-spain/archive/8.0.zip"

export > /etc/skel/initrc
/usr/local/bin/odoo-install
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
cd /opt
$PYTHON_BIN -m compileall .
cd /usr/lib/python2.7/site-packages && python -m compileall .
/usr/local/bin/clean.sh

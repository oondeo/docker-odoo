#!/sh

set -e

export ODOO_MODULES="https://github.com/OCA/l10n-spain/archive/8.0.zip"
export  PYTHON_MODULES="flanker"


export > /etc/skel/initrc
$PIP_BIN --no-cache-dir install $PYTHON_MODULES
/usr/local/bin/odoo-install
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
cd /opt
$PYTHON_BIN -m compileall .
cd /usr/lib/python2.7/site-packages && python -m compileall .
install-deps /opt /usr/lib/python2.7/site-packages
/usr/local/bin/clean.sh

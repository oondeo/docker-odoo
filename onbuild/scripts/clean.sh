#!/bin/sh

rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
find $PYTHON_DIR/site-packages "*.py" -and -not -name "__*" -exec rm -f {} \;
find /opt -name "*.py" -and -not -name "__*" -exec rm -f {} \;
npm uninstall -g less less-plugin-clean-css
gem uninstall -x -q -f compass
gem uninstall -x -q -f sass
apt-get purge -y --auto-remove $BUILD_PACKAGES
rm -rf /usr/lib/node_modules
rm -rf /usr/lib/ruby
rm -rf /app/*

exit 0

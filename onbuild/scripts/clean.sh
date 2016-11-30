#!/bin/sh

rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
find /usr/lib/python2.7 -name "*.py" -and -not -name "__*" -exec rm -f {} \;
find /opt -name "*.py" -and -not -name "__*" -exec rm -f {} \;
npm uninstall -g less less-plugin-clean-css
gem uninstall -x -q -f compass
gem uninstall -x -q -f sass
apk del --no-cache .builddeps
rm -rf /usr/lib/node_modules
rm -rf /usr/lib/ruby

exit 0

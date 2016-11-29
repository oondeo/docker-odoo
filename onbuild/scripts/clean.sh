#!/bin/sh

rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
find /opt -name "*.py" -exec rm -f {} \;
npm uninstall -g less less-plugin-clean-css
gem uninstall -x -q sass
apk del --no-cache .builddeps
rm -rf /usr/lib/node_modules
rm -rf /usr/lib/ruby

exit 0

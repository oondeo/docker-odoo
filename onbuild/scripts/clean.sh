#!/bin/sh

if [ "$DEVELOP" !=  "yes" ]; then
    rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian
    find /opt -name "*.py" -exec rm -f {} \;
    apk del --no-cache .builddeps
    rm -rf /usr/lib/node_modules
    exit 0
fi

exit 0

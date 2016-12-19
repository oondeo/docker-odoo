#!/sh

set -e
export ODOO_VERSION="10.0"
export ODOO_SERVER="$PYTHON_BIN odoo-bin" \
  ODOO_MODULE_FILE="__manifest__.pyc" \
  ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
  ODOO_TARBALL_DIR="OCB-$ODOO_VERSION"

export ODOO_MODULES=""
export PHANTOMJS_VERSION=2.11
export  PYTHON_MODULES="wdb pyinotify openupgradelib flanker odoo_gateway"
export WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

export > /etc/skel/initrc

  mkdir -p /usr/share && \
  cd /usr/share \
  && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/$PHANTOMJS_VERSION/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && paxctl -Cm /usr/share/phantomjs/phantomjs \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs

$PIP_BIN install $PYTHON_MODULES
/usr/local/bin/odoo-install
cd /opt
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian

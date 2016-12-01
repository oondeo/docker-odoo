#!/sh

set -e
export ODOO_MODULES="https://github.com/oondeo/git-install/archive/8.0.zip"
export PHANTOMJS_VERSION=2.11
export  PYTHON_MODULES="wdb pyinotify openupgradelib flanker odoo_gateway"
export WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost


export > /etc/skel/initrc

apk add --no-cache -t .rundeps fontconfig && \
  mkdir -p /usr/share && \
  cd /usr/share \
  && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/$PHANTOMJS_VERSION/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs

$PIP_BIN --no-cache-dir install $PYTHON_MODULES
/usr/local/bin/odoo-install
#fix pillow
CFLAGS="$CFLAGS -L/lib"
$PIP_BIN -I --no-cache-dir Pillow
cd /opt
$PYTHON_BIN -m compileall .
cd /usr/lib/python2.7/site-packages && python -m compileall .
install-deps /opt /usr/lib/python2.7/site-packages
rm -rf $ODOO_HOME/doc $ODOO_HOME/setup* $ODOO_HOME/debian

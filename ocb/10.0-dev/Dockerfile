FROM oondeo/odoo-deps:onbuild
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV PHANTOMJS_VERSION=2.1.1

RUN apk add --no-cache curl \
    && cd /tmp && curl -sL -o phantomjs.tar.bz2 \
    https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    apk del curl && rm -rf /tmp/* /root/.cache || true

ENV ODOO_SERVER="$VENV_HOME/bin/python odoo-bin" \
    ODOO_VERSION="10.0"

ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \
    DEVELOP="yes" \
    PYTHON_MODULES="$PYTHON_MODULES flanker odoo_gateway pyinotify openupgradelib wdb"

CMD ["launch"]

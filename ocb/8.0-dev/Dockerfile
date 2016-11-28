FROM oondeo/odoo-deps:onbuild
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ENV PYTHON_MODULES="$PYTHON_MODULES pyinotify openupgradelib wdb"
ENV PHANTOMJS_VERSION=2.1.1

RUN curl -sL -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs.tar.bz2 && \
    cp phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs* && \
#cleanup
    rm -rf /tmp/* /root/.cache /var/lib/apt || true


CMD ["launch"]

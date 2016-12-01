FROM oondeo/odoo-deps:onbuild
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>

ONBUILD COPY . /app
ONBUILD RUN  build-install \
    && chmod +x /app/build.sh && /app/build.sh  \
    && rm -rf /tmp/*  ~/.cache

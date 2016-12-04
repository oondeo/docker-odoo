FROM oondeo/odoo:8
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>


COPY . /app
RUN  build-install \
    && chmod +x /app/build.sh && /app/build.sh  \
    && rm -rf /tmp/*  ~/.cache

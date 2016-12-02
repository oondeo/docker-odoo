FROM oondeo/odoo:8-alpine
MAINTAINER Juan Ramon Alfaro <info@oondeo.es>



COPY . /app
RUN chmod +x /app/build.sh && /app/build.sh \
  && rm -rf ~/.cache /tmp/*

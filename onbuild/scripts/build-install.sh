#!/sh

apk add --no-cache -t .builddeps $BUILD_PACKAGES
npm install -g less less-plugin-clean-css || true
npm cache clean || true
rm -rf /usr/lib/node_modules/npm /tmp/* /root/.cache/*

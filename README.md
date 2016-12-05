# Dockerized Odoo #

An [Odoo][] 8 server installed in [Alpine][].
Based on [yajo/odoo][] image.
This image is intended to use in other Dockerfile odoo is installed using ONBUILD
instruction in dir /opt/odoo and additional addons in /opt/odoo_addons_src
All environment variables are optional


##Example Dockerfile

ENV  ODOO_VERSION="8.0"
# set ODOO_WORKERS in prod
# Variables used by the launch scripts
ENV LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8  \
     XDG_DATA_HOME="/var/lib/odoo/.local/share" \
     ODOO_HOME="/opt/odoo" \
     ODOO_ADDONS_HOME="/opt/odoo_addons_src" \
     ODOO_SERVER="/opt/odoo/.env/bin/python odoo.py" \
     UNACCENT=True \
     PYTHON_BIN="/opt/odoo/.env/bin/python" \
     PIP_BIN="/opt/odoo/.env/bin/pip" \
     OCA_URL="https://github.com/OCA" \
     ODOO_URL="https://github.com/OCA/OCB/archive/$ODOO_VERSION.zip" \
     ODOO_TARBALL_DIR="OCB-$ODOO_VERSION" \
     ODOO_MODULES="https://github.com/OCA/l10n-spain.git" \
     PYTHON_MODULES="unicodecsv ofxparse" \
     DEVELOP="no" \
     BUILD_PACKAGES=" \
        alpine-sdk postgresql-dev libxml2-dev libffi-dev freetype-dev jpeg-dev \
        libwebp-dev tiff-dev libpng-dev lcms2-dev openjpeg-dev zlib-dev openldap-dev \
        libxslt-dev \
        bash \
        git \
		bzip2-dev \
		gcc \
		gdbm-dev \
		libc-dev \
		linux-headers \
		make \
		ncurses-dev \
		openssl \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		zlib-dev \
        sassc@comunity \
        " \
    RUN_PACKAGES="libpng libjpeg zlib"



## Security

You **must** change the database administration password by adding
`--env ADMIN_PASSWORD=blahblah`, or it will default to `admin`, which is too
insecure for production environments.

Odoo does not allow to be run as the user `postgres`, which is the default.
You **must** change it with `--env POSTGRES_USER=other_user`.

Also, to block access to your [PostgreSQL][] database, you **should** either
don't expose its port (you do not need to do it anyway) or use
`--env POSTGRES_PASSWORD=something_secure` when launching the `db` container.

You are setting up a service which will recieve passwords from users.
As such, you should use HTTPS for production. The easiest way to
set it up will be proxying Odoo with [yajo/https-proxy][].

**Never** add the debugger in production.

## tl;dr: [Docker Compose][] example

    # Odoo server itself
    app:
        image: oondeo/odoo:8.0
        # Allow colorized output
        tty: true
        environment:
            # Default values (you **must** change ADMIN_PASSWORD)
            ADMIN_PASSWORD: admin
            DATABASE: odoo
            ODOO_SERVER: odoo.py
            UNACCENT: True
            WDB_NO_BROWSER_AUTO_OPEN: True
            WDB_SOCKET_SERVER: wdb
            WDB_WEB_PORT: 1984
            WDB_WEB_SERVER: localhost
            XDG_DATA_HOME="/var/lib/odoo"
            ODOO_SERVER="python odoo.py"
            UNACCENT=True
     # If you are going to use the HTTPS proxy for production,
        # don't expose any ports
        ports:
            - "8069:8069"
            - "8072:8072"
        volumes:
            # Assuming you have an addons subfolder in the working tree
            - ./addons:/mnt/extra-addons:ro,Z
        volumes_from:
            - appdata
        links:
            - db
            - wdb # Debugger, only for development
        # This is the default command
        command: launch

    # Hold separately the volumes of Odoo variable data
    appdata:
        image: yajo/odoo:data

    # PostgreSQL server
    db:
        image: postgres:9.2
        environment:
            # You **must** change these
            POSTGRES_USER: odoo
            POSTGRES_PASSWORD: something_secure
        volumes_from:
            - dbdata

    # PostgreSQL data files
    dbdata:
        image: postgres:9.2
        command: "true"

    # For development, add a debugger
    wdb:
        image: yajo/wdb-server
        ports:
            - "1984:1984"

    # For production, you will need HTTPS
    https:
        image: yajo/https-proxy
        ports:
            - "80:80"
            - "443:443"
        links:
            - app:www
        environment:
            PORT: 8069
            # In case you have your SSL key & certs, put them here:
            KEY: |
                -----BEGIN PRIVATE KEY-----
                [some random base64 garbage]
                -----END PRIVATE KEY-----
            CERT: |
                -----BEGIN CERTIFICATE-----
                [some random base64 garbage]
                -----END CERTIFICATE-----
                -----BEGIN CERTIFICATE-----
                [you will probably have more of these sections]
                -----END CERTIFICATE-----

The above is a sample `docker-compose.yml` file. This image is a little bit
complex because it has many launcher scripts and needs some links and volumes
to work properly, but if you understand the above, you almost got it all.

## Usage

To get up and running using the docker CLI:

    # PostgreSQL data files
    docker run -d --name odoo_dbdata postgres:9.2 true

    # PostgreSQL server
    docker run -d --name odoo_dbsrv --volumes-from odoo_dbdata \
        -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=something_secure \
        postgres:9.2

    #install unaccent extension on POSTGRES
    CREATE extension unaccent

    # Hold separately the volumes of Odoo variable data
    docker run -d --name odoo_appdata yajo/odoo:data

    # Odoo server itself
    docker run -d --name odoo_app --link odoo_dbsrv:db \
        --volumes-from odoo_appdata --publish-all \
        -e ADMIN_PASSWORD=something_more_secure oondeo/odoo

Follow instructions from [postgres][] to understand the PostgreSQL part.

Maybe you prefer to change `--publish-all` for `-p 1984 -p 8069 -p 8072`.

### Scripts available

-   `debug`: Use for debugging with [wdb][] from the start. See section
    *Debugging* below.

-   `launch`: **DEFAULT**. All other scripts end up running this one.

    You can choose which upstream server to run by adding
    `--env ODOO_SERVER=script_name` to the `docker run` command.

    Choose from:

    -   `openerp-server`: To run just the web server (port 8069).

    -   `openerp-gevent`: To run the web server with live chat (port 8072).

    -   `odoo.py`: **DEFAULT**. Like the first, with some more options.

-   `pot`: This prints a `*.pot` template to translate your module.

    Usage:

        docker run --rm --link odoo_dbsrv:db oondeo/odoo pot one_module,other

-   `unittest`: This runs the server in unit test mode.

    Usage:

        docker run -P --rm --link odoo_dbsrv:db oondeo/odoo unittest one_module,other

    [PhantomJS][] is included.

### Reading logs

By default, logs are printed to `STDOUT` so you can read them with
the usual command:

    docker logs odoo_app

This is more standard and works better with [Docker Compose][].

If you need persistent logs, use volumes from `oondeo/odoo:data` and configure
`/etc/odoo/openerp-server.conf` to store them in `/var/log/odoo/`.

## Mounting extra addons for Odoo

Extra addons must be located in `/var/lib/odoo/src/<repo>/<addon>/` or `/var/lib/odoo/addons` for development.
In production you may use `/etc/odoo/src/<repo>/<addon>/` or `/etc/odoo/addons/<addon>`

Official mountpoint `/mnt/extra-addons` also works

How you put them there does not matter. I will give you some ideas:

### Mounting an addons folder from the host

Recommended for developing.

Add `--volume /path/to/addons/folder/in/host:/opt/odoo/extra-addons:ro` when
executing step 2 of above instructions. The mounted folder must have read
permissions for the docker process, or it will fail without notice.

The `:ro` part means read-only. You will probably want that.

### Subclassing this repository

Recommended for production.

A simple `Dockerfile` like this can help:

    FROM oondeo/odoo:8.0
    ADD src /var/lib/odoo/

You should obviously have an `extra-addons` folder in the directory tree.
Then, run:

    cd /path/to/my/subrepository
    docker build --tag my-odoo .

## Mounting Odoo itself

Maybe you are a core Odoo developer, or want to make your own fork to fix
something, or want to use a variant such as [OCB][]. How to do it?


You should have a folder tree similar to this one:

    app/
       /data/
            /addons/
                    /one_module/
                    /...
            /src/
                    /one-repo/
                             /one_module/
                                        /__openerp__.py
                                        /__init__.py
                                        /...
                    /other-repo/
                    /...
       /my-odoo-fork/
                    /addons/
                    /openerp/
                            /addons/
                            /...
                    /...
    docker-compose.yml
    ...

And now, `docker-compose.yml` should have:

    app:
        volumes:
            ./app/my-odoo-fork:/opt/odoo:ro,Z
            ./app/data:/var/lib/odoo:rw,Z
    [... etc.]

Since everything is mounted from your computer, you can develop quickly, debug,
etc.

### Production

If you plan to use this image in production, I recommend ussing a custom
Dockerfile to build everything instead of mounting volumes, at least to have an
easier to reproduce environment.

This is a sample production `Dockerfile`:

    FROM oondeo/odoo:8.0

    # Install dependencies for your custom addons
    RUN yum -y install some-centos-epel-package &&\
        pip install some-pypi-package &&\
        yum clean all


There you have a production-ready image!

## Debugging

This image comes with [wdb][] client preinstalled.

To use the debugger, you need to link it to a [oondeo/wdb][] container:

    docker run -p 1984:1984 --name odoo_wdb oondeo/wdb
    docker run -p 80:8069 --link odoo_dbsrv:db --link odoo_wdb:wdb oondeo/odoo

Adding this line anywhere in your modules will pause it for debugging:

    import wdb; wdb.set_trace()

You will see a message like this one when Odoo executes that line:

    You can now launch your browser at http://$WDB_WEB_SERVER:$WDB_WEB_PORT/debug/session/some-long-random-stuff

Open the browser there and debug.

To debug Odoo from the start, run the `debug` script:

    docker run -P --link odoo_dbsrv:db --link odoo_wdb:wdb oondeo/odoo debug

To debug Odoo from the start in unittest mode, use:

    docker run -P --link odoo_dbsrv:db --link odoo_wdb:wdb oondeo/odoo debug unittest one_module,other

## Image tags available

The repository [oondeo/odoo][] has several versions of Odoo.

Not all tags are tested by me, so if you find bugs in any of them, please
create a BitBucket issue.

You can use the automatic `latest` and `master` tags, but I strongly recommend
using the number-versioned ones.

### Tags

These are installed from [OCB][]. Can be useful if there are fixes that you
need.

- `latest`: Latest stable version with support from community. Right now it points to `ocb-8.0`.
- `8.0`: Stable.
- `9.0`: Stable. Not tested by me.
- `10.0`: Stable. Not tested by me.

### Deprecated tags

These tags were used some time ago, but right now are not updated anymore:

-   `rpm8.0`: It was the same as `latest`.
-   `pip8.0`: It used [Pip][] and [Git][] to download and install [Odoo][] from
    [the official main source code repository](https://github.com/odoo/odoo).


##############################################
# Multiprocessing options
# Specify the number of workers, 0 disable prefork mode.
workers = 2
# Maximum allowed virtual memory per worker, when reached the worker be reset after the current request (default 671088640 aka 640MB)
limit_memory_soft = 888777666
# Maximum allowed virtual memory per worker, when reached, any memory allocation will fail (default 805306368 aka 768MB)
limit_memory_hard = 1999888777
# Maximum allowed CPU time per request (default 60)
limit_time_cpu = 80
# Maximum allowed Real time per request (default 120)
limit_time_real = 120
# Maximum number of request to be processed per worker (default 8192)
limit_request = 12000
# port for gevent processes has  worker (default 8072)
# reverse proxy 8072 port to the external 80, only for location /longpolling (in nginx this is done with a second location)
longpolling_port = 8083


[Alpine]: http://alpinelinux.org/
[Docker Compose]: http://www.fig.sh/
[Git]: http://git-scm.com/
[Odoo]: https://www.odoo.com/
[OCB]: https://github.com/OCA/OCB
[Pip]: https://pip.pypa.io/en/latest/
[wdb]: https://github.com/Kozea/wdb
[oondeo/wdb-server]: https://registry.hub.docker.com/u/oondeo/wdb-server/
[RPM]: http://rpm.org/
[PhantomJS]: http://phantomjs.org/
[PostgreSQL]: http://www.postgresql.org/
[postgres]: https://registry.hub.docker.com/_/postgres/
[yajo/https-proxy]: https://registry.hub.docker.com/u/oondeo/https-proxy/
[oondeo/odoo]: https://registry.hub.docker.com/u/oondeo/odoo/
[yajo/odoo]: https://registry.hub.docker.com/u/oondeo/odoo/yajo/odoo

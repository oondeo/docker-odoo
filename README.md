# Dockerized Odoo #

An [Odoo][]  server installed in [Debian][] Jessie. Basedin yajo/odoo image.

-dev tags have installed wdb debug.

## Security

Set WORKERS variable in production.

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
set it up will be proxying Odoo with [oondeo/https-proxy][].

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
        # If you are going to use the HTTPS proxy for production,
        # don't expose any ports
        ports:
            - "8069:8069"
            - "8072:8072"
        volumes:
            # Assuming you have an addons subfolder in the working tree
            - ./addons:/opt/odoo/extra-addons:ro,Z
        volumes_from:
            - appdata
        links:
            - db
            - wdb # Debugger, only for development
        # This is the default command
        command: launch

    # Hold separately the volumes of Odoo variable data
    appdata:
        image: oondeo/odoo:data

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
        image: oondeo/wdb-server
        ports:
            - "1984:1984"

    # For production, you will need HTTPS
    https:
        image: oondeo/https-proxy
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

    # Hold separately the volumes of Odoo variable data
    docker run -d --name odoo_appdata oondeo/odoo:data

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

Extra addons must be located in `/mnt/extra-addons/<repo>/<addon>/`.

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
    ADD extra-addons /mnt/

You should obviously have an `extra-addons` folder in the directory tree.
Then, run:

    cd /path/to/my/subrepository
    docker build --tag my-odoo .

## Mounting Odoo itself

Maybe you are a core Odoo developer, or want to make your own fork to fix
something, or want to use a variant such as [OCB][]. How to do it?

Well, the most important thing you need to know is that Odoo is installed in
`/usr/lib/python2.7/site-packages/openerp/`.

You should have a folder tree similar to this one:

    app/
       /extra-addons/
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

Then you need to link the extra core addons inside the `extra-addons` folder,
as if it were an external repository:

    $ ln -sT ../my-odoo-fork/addons app/extra-addons/core-addons

And now, `docker-compose.yml` should have:

    app:
        volumes:
            ./app:/opt/odoo:ro,Z
            ./app/my-odoo-fork/openerp:/usr/lib/python2.7/site-packages/openerp:ro,Z
    [... etc.]

Now we have the custom addons and the extra core addons in
`/opt/odoo/extra-addons`, and your Odoo fork in
`/usr/lib/python2.7/site-packages/openerp`.

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

    # This time, we link it to avoid wasting disk space
    RUN rm -Rf /usr/lib/python2.7/site-packages/openerp &&\
        ln -s /opt/odoo/my-odoo-fork/openerp /usr/lib/python2.7/site-packages/

    # Add your custom code
    ADD app /opt/odoo

    # Now compile all Python files to have better performance
    RUN python -m compileall /opt/odoo

    # This will fix possible permission issues
    RUN chown --recursive odoo:odoo /opt/odoo &&\
        chmod --recursive u=rwX,go=rX /opt/odoo

There you have a production-ready image!

## Debugging

This image comes with [wdb][] client preinstalled.

To use the debugger, you need to link it to a [oondeo/wdb-server][] container:

    docker run -p 1984:1984 --name odoo_wdb oondeo/wdb-server
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

### Data

The `data` tag is a shortcut used to create a volumes in `/home/odoo` and
`/var/{lib,log}/odoo` to store variable data.

Instead, you can use any other tag running command `/usr/bin/true`, and save a
little disk space. It's almost the same.

### Core

Core tags are installed from upstream Odoo code, using [nightly
builds](http://nightly.odoo.com/) (RPM version, of course).

- `latest`: Latest stable version. Right now it points to `9.0`.
- `master`: Latest development version. Right now it points to `10.0`.
- `8.0`: Stable.
- `9.0`: Stable. Not tested by me.
- `10.0`: Unstable. Not tested by me.

### OCB

These are installed from [OCB][]. Can be useful if there are fixes that you
need.

- `ocb-latest`: Latest stable version. Right now it points to `ocb-9.0`.
- `ocb-8.0`: Stable. Not tested by me.
- `ocb-9.0`: Stable. Not tested by me.

### Deprecated tags

These tags were used some time ago, but right now are not updated anymore:

-   `rpm8.0`: It was the same as `latest`.
-   `pip8.0`: It used [Pip][] and [Git][] to download and install [Odoo][] from
    [the official main source code repository](https://github.com/odoo/odoo).


[CentOS]: http://centos.org/
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
[oondeo/https-proxy]: https://registry.hub.docker.com/u/oondeo/https-proxy/
[oondeo/odoo]: https://registry.hub.docker.com/u/oondeo/odoo/

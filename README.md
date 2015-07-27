# Dockerized Odoo #

An [Odoo][] 8 server installed in [CentOS][] 7.

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
        image: yajo/odoo:8.0
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
            - addons:/opt/odoo/extra-addons:ro
        volumes_from:
            - appdata
        links:
            - db
            - wdb # Debugger, only for development
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

    # For production, you will likely use HTTPS
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

    # Hold separately the volumes of Odoo variable data
    docker run -d --name odoo_appdata yajo/odoo:data

    # Odoo server itself
    docker run -d --name odoo_app --link odoo_dbsrv:db \
        --volumes-from odoo_appdata --publish-all \
        -e ADMIN_PASSWORD=something_more_secure yajo/odoo

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

        docker run --rm --link odoo_dbsrv:db yajo/odoo pot one_module,other

-   `unittest`: This runs the server in unit test mode.

    Usage:

        docker run -P --rm --link odoo_dbsrv:db yajo/odoo unittest one_module,other

### Reading logs

By default, logs are printed to `STDOUT` so you can read them with
the usual command:

    docker logs odoo_app

This is more standard and works better with [Docker Compose][].

If you need persistent logs, use volumes from `yajo/odoo:data` and configure
`/etc/odoo/openerp-server.conf` to store them in `/var/log/odoo/`.

## Mounting extra addons for Odoo

Extra addons must be located in `/opt/odoo/extra-addons/<repo>/<addon>/`.

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

    FROM yajo/odoo
    ADD extra-addons /opt/odoo/

You should obviously have an `extra-addons` folder in the directory tree.
Then, run:

    cd /path/to/my/subrepository
    docker build --tag my-odoo .

## Debugging

This image comes with [wdb][] client preinstalled.

To use the debugger, you need to link it to a [yajo/wdb-server][] container:

    docker run -p 1984:1984 --name odoo_wdb yajo/wdb-server
    docker run -p 80:8069 --link odoo_dbsrv:db --link odoo_wdb:wdb yajo/odoo

Adding this line anywhere in your modules will pause it for debugging:

    import wdb; wdb.set_trace()

You will see a message like this one when Odoo executes that line:

    You can now launch your browser at http://$WDB_WEB_SERVER:$WDB_WEB_PORT/debug/session/some-long-random-stuff

Open the browser there and debug.

To debug Odoo from the start, run the `debug` script:

    docker run -P --link odoo_dbsrv:db --link odoo_wdb:wdb yajo/odoo debug

To debug Odoo from the start in unittest mode, use:

    docker run -P --link odoo_dbsrv:db --link odoo_wdb:wdb yajo/odoo debug unittest one_module,other

## Image tags available

The repository [yajo/odoo][] has these active tags:

-   `latest`: Right now it points to `8.0`.
-   `8.0`: It uses the official [upstream `8.0` nightly RPM
    repository](http://nightly.odoo.com/8.0/nightly/rpm/)
    and tries to install every dependency possible with [RPM][].
    If something is not available as RPM package, it will install it other way.
-   `9.0`: Like `8.0`, but installed from the official [upstream `master`
    nightly RPM repository](http://nightly.odoo.com/master/nightly/rpm).
    **It is considered unstable right now.***
-   `data`: Used to create a volumes in `/home/odoo` and `/var/{lib,log}/odoo`
    to store variable data.

### Deprecated tags

These tags were used some time ago, but right now are not updated anymore:

-   `rpm8.0`: It was the same as `latest`.
-   `pip8.0`: It used [Pip][] and [Git][] to download and install [Odoo][] from
    [the official main source code repository](https://github.com/odoo/odoo).


[CentOS]: http://centos.org/
[Docker Compose]: http://www.fig.sh/
[Git]: http://git-scm.com/
[Odoo]: https://www.odoo.com/
[Pip]: https://pip.pypa.io/en/latest/
[wdb]: https://github.com/Kozea/wdb
[yajo/wdb-server]: https://registry.hub.docker.com/u/yajo/wdb-server/
[RPM]: http://rpm.org/
[PostgreSQL]: http://www.postgresql.org/
[postgres]: https://registry.hub.docker.com/_/postgres/
[yajo/https-proxy]: https://registry.hub.docker.com/u/yajo/https-proxy/
[yajo/odoo]: https://registry.hub.docker.com/u/yajo/odoo/

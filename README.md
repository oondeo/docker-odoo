# Dockerized Odoo #

An [Odoo][] 8 server installed in [CentOS][] 7.

## Security

You **must** change the database administration password by adding
`--env ADMIN_PASSWD=blahblah`, or it will default to `admin`, which is too
insecure for production environments.

## tl;dr: [Fig][] example

    app:
        image: yajo/odoo:latest
        environment:
            # Default values (you **must** change ADMIN_PASSWD)
            ADMIN_PASSWD: admin
            DATABASE: odoo
            ODOO_SERVER: odoo.py
            UNACCENT: True
            WDB_WEB_SERVER: localhost
            WDB_WEB_PORT: 1984
        ports:
            - "1984:1984"
            - "8069:8069"
            - "8072:8072"
        volumes:
            - addons:/opt/odoo/extra-addons
        volumes_from:
            - appdata
        links:
            - db
        command: launch

    appdata:
        image: yajo/odoo:data

    db:
        image: yajo/postgres:9.2
        environment:
            # Default values
            USER: docker
            PASSWORD: docker
        volumes_from:
            - dbdata

    dbdata:
        image: yajo/postgres:data

The above is a sample `fig.yml` file. This image is a little bit complex
because it has many launcher scripts and needs some links and volumes to work
properly, but if you understand the above, you almost got it all.

## Usage

1.  Follow instructions from [yajo/postgres][] to:

    - Create the PostgreSQL server container:

            docker run --detach --name odoo_dbsrv yajo/postgres:9.2

    - Split data files from database server.
    - Change database user and password.

2.  Create the [Odoo][] app container, and link it to the database:

        docker run --detach --name odoo_app --link odoo_dbsrv:db --publish-all yajo/odoo

    Maybe you prefer to change `--publish-all` for
    `--publish 1984:1984 --publish 8069:8069 --publish 8072:8072`.

### Scripts available

-   `debug`: Use for debugging. See section *Debugging* below.

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

### Saving variable data separately

#### Auto-installed addons, attachments, sessions

By default, Odoo saves those in `/var/lib/odoo/`.

If you don't want them to disappear when you drop and recreate your container,
you need to store them separately:

    docker run --detach --name odoo_files yajo/odoo:data
    docker run -d --name odoo_app --volumes_from odoo_files yajo/odoo

#### Logs

If you configure Odoo to store logs in `/var/log/odoo/`, you have
persistent logs for free with the above method.

However, by default, logs are printed to `STDOUT` so you can read them with
the usual command:

    docker logs odoo_app

This is more standard and works better with [Fig][].

## Mounting extra addons for Odoo

Extra addons must be located in `/opt/odoo/extra-addons/<repo>/<addon>/`.

How you put them there does not matter. I will give you some ideas:

### Mounting an addons folder from the host

Good idea for developing.

Add `--volume /path/to/addons/folder/in/host:/opt/odoo/extra-addons:ro` when
executing step 2 of above instructions. The mounted folder must have read
permissions for the docker process, or it will fail without notice.

### Subclassing this repository

A simple `Dockerfile` like this can help:

    FROM yajo/odoo
    ADD extra-addons /opt/odoo/

You should obviously have an `extra-addons` folder in the directory tree.
Then, run:

    cd /path/to/my/subrepository
    docker build --tag my-odoo .

## Debugging

This image comes with [wdb][] preinstalled. See its page for documentation.

Adding this line anywhere will interrupt the execution in the wdb debugger:

    import wdb;wdb.set_trace()

You will see a message like this one when this happens:

    Unable to open browser, please go to http://localhost:1984/debug/session/some-long-random-stuff

This assumes that you ran the container with the option `-p 1984:1984` in a
local machine. If you want to change the `localhost:1984` part, you can
do so with `-e WDB_WEB_SERVER=example.com -e WDB_WEB_PORT=42`.

To debug your modules, you will need to start the container with the script
`debug` (see above section *Scripts available*):

    docker run -P --link odoo_dbsrv:db yajo/odoo debug

To debug Odoo from the start, add the `start` keyword at the end:

    docker run -P --link odoo_dbsrv:db yajo/odoo debug start

To debug your unit tests, run it as:

    docker run -P --link odoo_dbsrv:db yajo/odoo debug unittest one_module,other

As long as you don't use the `debug` script, the wdb server does not start,
and port 1984 does not listen to anything, so you don't need to expose it.

## Image tags available

The repository [yajo/odoo][] has these active tags:

-   `latest`: Right now it points to `8.0`.
-   `8.0`: It uses the official
    [upstream nightly RPM repository](http://nightly.odoo.com/8.0/nightly/rpm/)
    and tries to install every dependency possible with [RPM][].
    If something is not available as RPM package, it will install it other way.
-   `data`: Used to create a volumes in `/var/{lib,log}/odoo` to store
    variable data.

### Deprecated tags

These tags were used some time ago, but right now are not updated anymore:

-   `rpm8.0`: It was the same as `latest`.
-   `pip8.0`: It used [Pip][] and [Git][] to download and install [Odoo][] from
    [the official main source code repository](https://github.com/odoo/odoo).


[CentOS]: http://centos.org/
[Fig]: http://www.fig.sh/
[Git]: http://git-scm.com/
[Odoo]: https://www.odoo.com/
[Pip]: https://pip.pypa.io/en/latest/
[wdb]: https://github.com/Kozea/wdb
[RPM]: http://rpm.org/
[yajo/postgres]: https://registry.hub.docker.com/u/yajo/postgres/
[yajo/odoo]: https://registry.hub.docker.com/u/yajo/odoo/

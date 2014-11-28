# Dockerized Odoo #

An [Odoo][] server installed in [CentOS][] 7.

## Security

You **must** change the database administration password by adding
`--env ADMIN_PASSWD=blahblah`, or it will default to `admin`, which is too
insecure for production environments.

## Usage

1.  Follow instructions from [yajo/postgres][] to:

    - Create the PostgreSQL server container:

            docker run --detach --name odoo_dbsrv yajo/postgres:9.2

    - Split data files from database server.
    - Change database user and password.

2.  Create the [Odoo][] app container, and link it to the database:

        docker run --detach --name odoo_app --link odoo_dbsrv:db --publish-all yajo/odoo

    Maybe you prefer to change `--publish-all` for
    `--publish 8069:8069 --publish 8072:8072`.

### Scripts available

-   `launch`: Default. Ultimately all other scripts end up running this one.

    You can choose which upstream server to run by adding
    `--env ODOO_SERVER=script_name` to the `docker run` command.

    Choose from:

    -   `openerp-server`: Default. To run just the web server (port 8069).

    -   `openerp-gevent`: To run the web server with live chat (port 8072).

    -   `odoo.py`: Like the first, with some more options.

-   `pot`: This prints a `*.pot` template to translate your module.

    Usage:

        docker run --rm --link odoo_dbsrv:db yajo/odoo pot one_module,other

-   `unittest`: This runs the server in unit test mode.

    Usage:

        docker run -P --rm --link odoo_dbsrv:db yajo/odoo unittest one_module,other

## Mounting extra addons for Odoo

Extra addons must be located in `/opt/odoo/extra-addons/<repo>/<addon>`.

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

This image comes with [pudb][] preinstalled. To debug your modules, simply add
this line anywhere:

    import pudb;pudb.set_trace()

That will interrupt the execution and display the pudb screen in your terminal.

## Image versions available

The repository [yajo/odoo][] has these versions (tags):

- `latest` or `rpm8.0`: It uses the official
  [upstream nightly RPM packages](http://nightly.openerp.com/8.0/nightly/rpm/)
  and tries to install every dependency possible with [RPM][].
- `pip8.0`: It uses [Pip][] and [Git][] to download and install [Odoo][] from
[the official main source code repository](https://github.com/odoo/odoo).


[CentOS]: http://centos.org/
[Git]: http://git-scm.com/
[Odoo]: https://www.odoo.com/
[Pip]: https://pip.pypa.io/en/latest/
[pudb]: https://pypi.python.org/pypi/pudb
[RPM]: http://rpm.org/
[yajo/postgres]: https://registry.hub.docker.com/u/yajo/postgres/
[yajo/odoo]: https://registry.hub.docker.com/u/yajo/odoo/

# Dockerized Odoo #

It uses the [upstream nightly RPM packages][1] in [CentOS][].

## Usage

1.  Follow instructions from [wyaeld/postgres][] to create the
    PostgreSQL server container.

        docker run --detach --name odoo_dbsrv wyaeld/postgres

    ### Additional information

    That repository has information about how to split your database data files
    from the database server itself, in case you want. Quick example:

        docker run --name odoo_dbdata wyaeld/postgres
        docker run --name odoo_dbsrv --detach --volumes-from odoo_dbdata wyaeld/postgres

    Also there you can find how to set up a different username, password and
    database name when creating the container. If you use instructions from
    there, those values will be used in the Odoo app container.

2.  Create the [Odoo][] app container, and link it to the database:

        docker run --detach --name odoo_app --link odoo_dbsrv:db --publish-all yajo/odoo

    ### Additional information

    Maybe you prefer to change `--publish-all` for `--publish 8072:8072`.

    You **should** change the database administration password by adding
    `--env ADMIN_PASSWD=blahblah`, or it will default to `admin`, which is too
    insecure for production environments.

    You can choose which script will the launcher run by adding
    `--env ODOO_SERVER=script_name`. Choose from:

    - `openerp-server`: Default. To run just the web server (port 8069).
    - `openerp-gevent`: To run the web server with live chat (port 8072).
    - `odoo.py`: Like the first, with some more options.

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


[1]: http://nightly.openerp.com/8.0/nightly/rpm/
[CentOS]: http://centos.org/
[Odoo]: https://www.odoo.com/
[wyaeld/postgres]: https://registry.hub.docker.com/u/wyaeld/postgres/

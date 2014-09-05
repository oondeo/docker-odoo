# Dockerized Odoo #

It uses the [upstream nightly RPM packages][1] in [CentOS][].

# Usage

1.  Follow instructions from [wyaeld/postgres][] to create the
    PostgreSQL server container.

        docker run --detach --name odoo_dbsrv wyaeld/postgres

    ### Additional information

    That repository has information about how to split your database data files
    from the database server itself, in case you want. Quick example:

        docker run --name odoo_dbdata wyaeld/postgres
        docker run --name odoo_dbsrv --detach \
            --volumes-from odoo_dbdata wyaeld/postgres

    Also there you can find how to set up a different username, password and
    database name when creating the container. If you use instructions from
    there, those values will be used in the Odoo app container.

2.  Create the [Odoo][] app container, and link it to the database:

        docker run --detach --name odoo_app --link odoo_dbsrv:db yajo/odoo

    ### Additional information

    You **should** change the database administration password by adding
    `--env ADMIN_PASSWD=blahblah`, or it will default to `admin`, which is too
    insecure for production environments.


[1]: http://nightly.openerp.com/8.0/nightly/rpm/
[CentOS]: http://centos.org/
[Odoo]: https://www.odoo.com/
[wyaeld/postgres]: https://registry.hub.docker.com/u/wyaeld/postgres/

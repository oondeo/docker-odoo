# Dockerized Odoo #

It uses the [upstream nightly packages for CentOS][1].

# Usage

1.  Follow instructions from [wyaeld/postgres][2] to create the PostgreSQL
    server containers (one for data, other for the server):

        # DB data container
        $ docker run --name odoo_dbdata wyaeld/postgres:data

        # DB server container
        $ docker run --detach --name odoo_dbsrv \
            --volumes-from odoo_dbdata \
            --env POSTGRESQL_USER=admin \
            --env POSTGRESQL_PASS=admin \
            --env POSTGRESQL_DB=odoo \
            wyaeld/postgres

    **Note:** Those `--env` are optional, but until [Odoo bug 953][3] gets
    fixed, `--env POSTGRESQL_PASS=admin` is needed to workaround it.

2.  Create the [Odoo][4] app container, and link it to the database:

        $ docker run --detach --name odoo_app \
            --link odoo_dbsrv:db \
            --env ADMIN_PASSWD=admin \
            yajo/odoo

    **Note:** If no `--env ADMIN_PASSWD`, it will default to `admin`,
    which is a security hole.


[1]: http://nightly.openerp.com/8.0/nightly/rpm/
[2]: https://registry.hub.docker.com/u/wyaeld/postgres/
[3]: https://github.com/odoo/odoo/issues/953
[4]: https://www.odoo.com/

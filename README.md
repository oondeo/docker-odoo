# Dockerized Odoo #

It uses the [upstream nightly packages for CentOS][1].

# Usage

1.  Create a PostgreSQL container from [nornagon/postgres][2].

        docker run -d --name odoo_db nornagon/postgres

2.  Create the [Odoo][3] app container, and link it to the database:

        docker run -d --name odoo_app --link odoo_db:db yajo/odoo


[1]: http://nightly.openerp.com/8.0/nightly/rpm/
[2]:  https://registry.hub.docker.com/u/nornagon/postgres/dockerfile/
[3]: https://www.odoo.com/

#!/bin/bash

# Patch configuration
echo "db_host = $DB_PORT_5432_TCP_ADDR" >> /etc/openerp/openerp-server.conf
echo "db_port = $DB_PORT_5432_TCP_PORT" >> /etc/openerp/openerp-server.conf

# Run with live chat
openerp-gevent --config /etc/openerp/openerp-server.conf

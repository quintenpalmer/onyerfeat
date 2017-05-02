#!/bin/bash
set -e
if [ $(psql -d postgres -q -t -c "select count(*) from pg_database where datname = 'pathfinder'") == 1 ]; then
    echo "you already have a pathfinder database, delete it first to restore"
    exit
fi

psql -d postgres -c "CREATE DATABASE pathfinder"
psql -d postgres -c "CREATE ROLE pathfinder_user WITH CREATEDB LOGIN"
psql -d postgres -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO pathfinder_user"

echo "restoring the schema"
psql -U pathfinder_user -d pathfinder -f schema.sql
echo "done restoring the schema"

if [ $# -eq 0 ]; then
    echo "inserting seed data"
    psql -U pathfinder_user -d pathfinder -f data.sql
    echo "done inserting data"
    exit
else
    if [ $1 == "schema" ]; then
        echo "only restoring the schema"
        exit
    else
        echo "only supported subcommand is 'schema' for schema-only restores"
        exit
    fi
fi

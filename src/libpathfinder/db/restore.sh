#!/bin/bash
if [ -e local_pf.db ]; then
    echo "you already have a local_pf.db file, remove it first"
    exit
fi
if [ $# -gt 0 ]; then
    if [ $1 == "schema" ]; then
        echo "restoring the schema only"
        sqlite3 local_pf.db "$(cat schema.sql)"
        echo "done restoring the schema"
        exit
    else
        echo "only supported subcommand is 'schema'"
        exit
    fi
else
    echo "bootstrapping schema and data"
    sqlite3 local_pf.db "$(cat bootstrap.sql)"
    echo "done restoring the schema and data"
    exit
fi

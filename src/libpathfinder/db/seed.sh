#!/bin/bash
if [ -e local_pf.db ]; then
    echo "you already have a local_pf.db file, remove it first"
    exit
fi
sqlite3 local_pf.db "$(cat schema.sql)"
sqlite3 local_pf.db "$(cat bootstrap.sql)"

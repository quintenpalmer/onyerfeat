#!/bin/bash
sqlite3 local_pf.db "$(cat schema.sql)"
sqlite3 local_pf.db "$(cat bootstrap.sql)"

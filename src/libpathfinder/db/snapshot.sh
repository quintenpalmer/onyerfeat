#!/bin/bash

sqlite3 local_pf.db '.schema' > schema.sql
sqlite3 local_pf.db '.dump' > bootstrap.sql

#!/bin/bash
set -e

pg_dump -s pathfinder > schema.sql
pg_dump -a pathfinder > data.sql

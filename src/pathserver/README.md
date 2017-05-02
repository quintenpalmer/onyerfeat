Pathfinder Character Sheet Server
=================================

Setup
-----
Install Rust and Cargo; rustup is a good option for this:
https://github.com/rust-lang-nursery/rustup.rs/#other-installation-methods

Install Postgresql:
* [https://www.postgresql.org/download/](https://www.postgresql.org/download/) is a good resource
* [Postgres.app](http://postgresapp.com/) is a good macos choice
    - you will have to go through an extra step to install the [command line tools](http://postgresapp.com/documentation/cli-tools.html)
    - I preferred to just add `export PATH="/Applications/Postgres.app/Contents/Versions/9.6/bin:$PATH"` to my bashrc

Create and seed the database by running

```
$ cd /path/to/app/src/libpathfinder/db/
$ ./restore.sh
```

This should create:
* a database called `pathfinder`
* a user `pathfinder_user`
* all needed tables
* reasonable working data seeded into said tables

How to
------
From a terminal:
```
$ cd /path/to/app/src/pathserver/
$ cargo run
```

Curl http://localhost:3000

The documentation for this to come, sorry!

Ta-da!

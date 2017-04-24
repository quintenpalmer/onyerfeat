Pathfinder Character Sheet Server
=================================

Setup
-----
Install Rust and Cargo; rustup is a good option for this:
https://github.com/rust-lang-nursery/rustup.rs/#other-installation-methods

Create and seed the database by running

```
$ cd /path/to/app/src/libpathfinder/db/
$ ./seed.sh
```

This should create a `local_pf.db` file that the app is configured to read from.

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

use std::path;

use rusqlite;

use libpathfinder_common::FromDB;

use libpathfinder_common::error::Error;
use models;

pub struct Datastore {
    conn: rusqlite::Connection,
}

impl Datastore {
    pub fn new<P: AsRef<path::Path>>(p: P) -> Result<Datastore, Error> {
        let conn = try!(rusqlite::Connection::open(p).map_err(Error::Rusqlite));
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: u32) -> Result<models::Character, Error> {
        models::Character::select_one(&self.conn, id)
    }
}

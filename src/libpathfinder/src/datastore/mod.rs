use std::path;

use rusqlite;

use libpathfinder_common::FromDB;
use libpathfinder_common::error;

use models;

#[derive(FromDB)]
#[from_db(table_name = "characters")]
struct Character {
    id: u32,
    name: String,
}

pub struct Datastore {
    conn: rusqlite::Connection,
}

impl Datastore {
    pub fn new<P: AsRef<path::Path>>(p: P) -> Result<Datastore, error::Error> {
        let conn = try!(rusqlite::Connection::open(p).map_err(error::Error::Rusqlite));
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: u32) -> Result<models::Character, error::Error> {
        let c = try!(Character::select_one(&self.conn, id));
        return Ok(models::Character {
            id: c.id,
            name: c.name,
        });
    }
}

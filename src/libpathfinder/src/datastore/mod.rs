use std::path;

use rusqlite;

use error::Error;
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
        let mut stmt = self.conn.prepare("SELECT id, name FROM characters WHERE id = ?1").unwrap();
        let character =
            try!(stmt.query_row(&[&id], |row| models::Character::new(row.get(0), row.get(1)))
                .map_err(Error::Rusqlite));

        return Ok(character);
    }
}

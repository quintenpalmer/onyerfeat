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
    ability_score_set_id: u32,
}

#[derive(FromDB)]
#[from_db(table_name = "ability_score_sets")]
struct AbilityScoreSet {
    id: u32,
    str: u32,
    dex: u32,
    con: u32,
    int: u32,
    wis: u32,
    cha: u32,
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
        let abs = try!(AbilityScoreSet::select_one(&self.conn, c.ability_score_set_id));
        return Ok(models::Character {
            id: c.id,
            name: c.name,
            ability_scores: models::AbilityScoreSet {
                str: abs.str,
                dex: abs.dex,
                con: abs.con,
                int: abs.int,
                wis: abs.wis,
                cha: abs.cha,
            },
        });
    }
}

use std::path;

use rusqlite;

use libpathfinder_common::FromDB;
use libpathfinder_common::error;

use models;

#[derive(FromDB)]
#[from_db(table_name = "characters")]
struct Character {
    id: i32,
    name: String,
    alignment_order: models::AlignmentOrder,
    alignment_morality: models::AlignmentMorality,
    ability_score_set_id: i32,
}

impl rusqlite::types::FromSql for models::AlignmentOrder {
    fn column_result(value: rusqlite::types::ValueRef) -> rusqlite::types::FromSqlResult<Self> {
        match value {
            rusqlite::types::ValueRef::Text(ref s) => {
                match s {
                    &"chaotic" => Ok(models::AlignmentOrder::Chaotic),
                    &"neutral" => Ok(models::AlignmentOrder::Neutral),
                    &"lawful" => Ok(models::AlignmentOrder::Lawful),
                    _ => Err(rusqlite::types::FromSqlError::InvalidType),
                }
            }
            _ => Err(rusqlite::types::FromSqlError::InvalidType),
        }
    }
}

impl rusqlite::types::FromSql for models::AlignmentMorality {
    fn column_result(value: rusqlite::types::ValueRef) -> rusqlite::types::FromSqlResult<Self> {
        match value {
            rusqlite::types::ValueRef::Text(ref s) => {
                match s {
                    &"evil" => Ok(models::AlignmentMorality::Evil),
                    &"neutral" => Ok(models::AlignmentMorality::Neutral),
                    &"good" => Ok(models::AlignmentMorality::Good),
                    _ => Err(rusqlite::types::FromSqlError::InvalidType),
                }
            }
            _ => Err(rusqlite::types::FromSqlError::InvalidType),
        }
    }
}

#[derive(FromDB)]
#[from_db(table_name = "ability_score_sets")]
#[allow(dead_code)]
struct AbilityScoreSet {
    id: i32,
    str: i32,
    dex: i32,
    con: i32,
    int: i32,
    wis: i32,
    cha: i32,
}

pub struct Datastore {
    conn: rusqlite::Connection,
}

impl Datastore {
    pub fn new<P: AsRef<path::Path>>(p: P) -> Result<Datastore, error::Error> {
        let conn = try!(rusqlite::Connection::open(p).map_err(error::Error::Rusqlite));
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: i32) -> Result<models::Character, error::Error> {
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
            alignment: models::Alignment {
                morality: c.alignment_morality,
                order: c.alignment_order,
            },
        });
    }
}

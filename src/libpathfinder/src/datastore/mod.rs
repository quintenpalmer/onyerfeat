use std::fmt;
use std::str;
use std::error as stderror;

use postgres;

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

impl postgres::types::FromSql for models::AlignmentOrder {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "chaotic" => Ok(models::AlignmentOrder::Chaotic),
                    "neutral" => Ok(models::AlignmentOrder::Neutral),
                    "lawful" => Ok(models::AlignmentOrder::Lawful),
                    _ => Err(Box::new(ParseError {})),
                }
            }
            _ => Err(Box::new(ParseError {})),
        }
    }

    fn accepts(ty: &postgres::types::Type) -> bool {
        match ty {
            &postgres::types::Type::Text => true,
            _ => false,
        }
    }
}

impl postgres::types::FromSql for models::AlignmentMorality {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "evil" => Ok(models::AlignmentMorality::Evil),
                    "neutral" => Ok(models::AlignmentMorality::Neutral),
                    "good" => Ok(models::AlignmentMorality::Good),
                    _ => Err(Box::new(ParseError {})),
                }
            }
            _ => Err(Box::new(ParseError {})),
        }
    }

    fn accepts(ty: &postgres::types::Type) -> bool {
        match ty {
            &postgres::types::Type::Text => true,
            _ => false,
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
    conn: postgres::Connection,
}

impl Datastore {
    pub fn new<T: postgres::params::IntoConnectParams>(c: T) -> Result<Datastore, error::Error> {
        let conn = try!(postgres::Connection::connect(c, postgres::TlsMode::None)
            .map_err(error::Error::PostgresConnect));
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

#[derive(Debug)]
struct ParseError {}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "could not parse from db")
    }
}

impl stderror::Error for ParseError {
    fn description(&self) -> &str {
        "could not parse from db"
    }
}

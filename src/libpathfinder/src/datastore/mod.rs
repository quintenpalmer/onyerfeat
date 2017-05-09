mod structs;

use postgres;

use libpathfinder_common::FromDB;
use libpathfinder_common::error;

use models;

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
        let c = try!(structs::Character::select_one(&self.conn, id));
        let abs = try!(structs::AbilityScoreSet::select_one(&self.conn, c.ability_score_set_id));
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
            player_name: c.player_name,
            meta_information: models::MetaInformation {
                class: c.class,
                race: c.race,
                deity: c.deity,
            },
        });
    }
}

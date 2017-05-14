mod structs;

use postgres;

use libpathfinder_common::FromRow;
use libpathfinder_common::TableNamer;
use libpathfinder_common::error;

use models;

pub struct Datastore {
    conn: postgres::Connection,
}

pub fn select_one_by_field<T, F>(conn: &postgres::Connection,
                                 table_name: &str,
                                 id_name: &str,
                                 id: F)
                                 -> Result<T, error::Error>
    where T: FromRow + TableNamer,
          F: postgres::types::ToSql
{
    let query = format!("SELECT * FROM {} WHERE {} = $1",
                        T::get_table_name(),
                        id_name);
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne(table_name.to_string()));
    }
    let row = rows.get(0);
    return T::parse_row(row);
}

pub fn select_one_by_id<T>(conn: &postgres::Connection,
                           table_name: &str,
                           id: i32)
                           -> Result<T, error::Error>
    where T: FromRow + TableNamer
{
    select_one_by_field(conn, table_name, "id", id)
}

impl Datastore {
    pub fn new<T: postgres::params::IntoConnectParams>(c: T) -> Result<Datastore, error::Error> {
        let conn = try!(postgres::Connection::connect(c, postgres::TlsMode::None)
            .map_err(error::Error::PostgresConnect));
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: i32) -> Result<models::Character, error::Error> {
        let c: structs::Character = try!(select_one_by_id(&self.conn, "characters", id));
        let creature: structs::Creature =
            try!(select_one_by_id(&self.conn, "creatures", c.creature_id));
        let abs: structs::AbilityScoreSet = try!(select_one_by_id(&self.conn,
                                                                  "ability_score_sets",
                                                                  creature.ability_score_set_id));
        let class: structs::Class = try!(select_one_by_id(&self.conn, "classes", c.class_id));
        return Ok(models::Character {
            id: c.id,
            name: creature.name,
            ability_scores: models::AbilityScoreSet {
                str: abs.str,
                dex: abs.dex,
                con: abs.con,
                int: abs.int,
                wis: abs.wis,
                cha: abs.cha,
            },
            ability_score_info: models::AbilityScoreInfo {
                str: models::ScoreAndMofidier {
                    score: abs.str,
                    modifier: calc_ability_modifier(abs.str),
                },
                dex: models::ScoreAndMofidier {
                    score: abs.dex,
                    modifier: calc_ability_modifier(abs.dex),
                },
                con: models::ScoreAndMofidier {
                    score: abs.con,
                    modifier: calc_ability_modifier(abs.con),
                },
                int: models::ScoreAndMofidier {
                    score: abs.int,
                    modifier: calc_ability_modifier(abs.int),
                },
                wis: models::ScoreAndMofidier {
                    score: abs.wis,
                    modifier: calc_ability_modifier(abs.wis),
                },
                cha: models::ScoreAndMofidier {
                    score: abs.cha,
                    modifier: calc_ability_modifier(abs.cha),
                },
            },
            alignment: models::Alignment {
                morality: creature.alignment_morality,
                order: creature.alignment_order,
            },
            player_name: c.player_name,
            meta_information: models::MetaInformation {
                class: class.name,
                race: creature.race,
                age: creature.age,
                deity: creature.deity,
                size: creature.size,
            },
            combat_numbers: models::CombatNumbers {
                max_hit_points: creature.max_hit_points,
                current_hit_points: creature.current_hit_points,
            },
        });
    }
}

fn calc_ability_modifier(i: i32) -> i32 {
    let rounded = if i % 2 == 0 {
        i
    } else if i > 0 {
        i - 1
    } else {
        i + 1
    };
    return (rounded - 10) / 2;
}

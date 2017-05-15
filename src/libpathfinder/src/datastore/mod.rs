mod structs;
mod queries;

use std::collections::HashMap;

use postgres;

use libpathfinder_common::FromRow;
use libpathfinder_common::TableNamer;
use libpathfinder_common::error;

use models;

pub struct Datastore {
    conn: postgres::Connection,
}

pub fn exec_and_select_by_field<T, F>(conn: &postgres::Connection,
                                      query: &'static str,
                                      id: F)
                                      -> Result<Vec<T>, error::Error>
    where T: FromRow,
          F: postgres::types::ToSql
{
    let stmt = try!(conn.prepare(query).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_all<T>(conn: &postgres::Connection) -> Result<Vec<T>, error::Error>
    where T: FromRow + TableNamer
{
    let query = format!("SELECT * FROM {}", T::get_table_name());
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_by_field<T, F>(conn: &postgres::Connection,
                             id_name: &str,
                             id: F)
                             -> Result<Vec<T>, error::Error>
    where T: FromRow + TableNamer,
          F: postgres::types::ToSql
{
    let query = format!("SELECT * FROM {} WHERE {} = $1",
                        T::get_table_name(),
                        id_name);
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_one_by_field<T, F>(conn: &postgres::Connection,
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
        return Err(error::Error::ManyResultsOnSelectOne(T::get_table_name().to_string()));
    }
    let row = rows.get(0);
    return T::parse_row(row);
}

pub fn select_one_by_id<T>(conn: &postgres::Connection, id: i32) -> Result<T, error::Error>
    where T: FromRow + TableNamer
{
    select_one_by_field(conn, "id", id)
}

impl Datastore {
    pub fn new<T: postgres::params::IntoConnectParams>(c: T) -> Result<Datastore, error::Error> {
        let conn = try!(postgres::Connection::connect(c, postgres::TlsMode::None)
            .map_err(error::Error::PostgresConnect));
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: i32) -> Result<models::Character, error::Error> {
        let character: structs::Character = try!(select_one_by_id(&self.conn, id));
        let creature: structs::Creature = try!(select_one_by_id(&self.conn, character.creature_id));
        let abs: structs::AbilityScoreSet = try!(select_one_by_id(&self.conn,
                                                                  creature.ability_score_set_id));
        let class: structs::Class = try!(select_one_by_id(&self.conn, character.class_id));

        let skills: Vec<structs::Skill> = try!(select_all(&self.conn));
        let trained_skills: Vec<structs::CharacterSkillChoice> =
            try!(select_by_field(&self.conn, "character_id", character.id));

        let sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice> =
            try!(exec_and_select_by_field(&self.conn,
                                          queries::CHARACTER_SUB_SKILLS_QUERY,
                                          character.id));

        return Ok(character.into_canonical(creature, abs, class, skills, trained_skills, sub_skills));
    }

    pub fn get_skills(&self) -> Result<Vec<models::ConcreteSkill>, error::Error> {
        let skills: Vec<structs::Skill> = try!(select_all(&self.conn));
        let mut ret_skills: Vec<models::ConcreteSkill> = skills.iter()
            .map(|x| -> models::ConcreteSkill {
                models::ConcreteSkill::Skill(models::Skill {
                    name: x.name.clone(),
                    ability: x.ability.clone(),
                })
            })
            .collect();
        let sub_skills: Vec<structs::SubSkill> = try!(select_all(&self.conn));
        let skill_constructors: Vec<structs::SkillConstructor> = try!(select_all(&self.conn));
        let skill_c_map = skill_constructor_map(&skill_constructors);
        for sub_skill in sub_skills.iter() {
            let constr = skill_c_map.get(&sub_skill.skill_constructor_id);
            let constructed = models::ConstructedSkill {
                name: constr.unwrap().name.to_string(),
                sub_skill: sub_skill.name.clone(),
                ability: constr.unwrap().ability.clone(),
            };
            ret_skills.push(models::ConcreteSkill::ConstructedSkill(constructed));
        }
        return Ok(ret_skills);
    }
}

fn skill_constructor_map<'a>(s: &'a Vec<structs::SkillConstructor>)
                             -> HashMap<i32, &'a structs::SkillConstructor> {
    let mut m = HashMap::new();
    for s in s.iter() {
        m.insert(s.id, s);
    }
    return m;
}

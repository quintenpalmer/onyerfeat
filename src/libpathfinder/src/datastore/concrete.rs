use std::collections::HashMap;

use postgres;

use libpathfinder_common::error;

use models;

use datastore::selects;
use datastore::structs;
use datastore::queries;
use datastore::convert;

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
        let character: structs::Character = try!(selects::select_one_by_id(&self.conn, id));
        let creature: structs::Creature = try!(selects::select_one_by_id(&self.conn,
                                                                         character.creature_id));
        let abs: structs::AbilityScoreSet = try!(selects::select_one_by_id(&self.conn,
                                                                  creature.ability_score_set_id));
        let class: structs::Class = try!(selects::select_one_by_id(&self.conn, character.class_id));

        let skills: Vec<structs::Skill> = try!(selects::select_all(&self.conn));
        let trained_skills: Vec<structs::CharacterSkillChoice> =
            try!(selects::select_by_field(&self.conn, "character_id", character.id));

        let sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice> =
            try!(selects::exec_and_select_by_field(&self.conn,
                                                   queries::CHARACTER_SUB_SKILLS_QUERY,
                                                   character.id));

        let class_skills: Vec<structs::ClassSkill> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));

        let class_sub_skills: Vec<structs::ClassSubSkill> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));

        let class_skill_constructors: Vec<structs::ClassSkillConstructor> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));


        return Ok(convert::into_canonical_character(character,
                                                    creature,
                                                    abs,
                                                    class,
                                                    skills,
                                                    trained_skills,
                                                    sub_skills,
                                                    class_skills,
                                                    class_sub_skills,
                                                    class_skill_constructors));
    }

    pub fn get_skills(&self) -> Result<Vec<models::ConcreteSkill>, error::Error> {
        let skills: Vec<structs::Skill> = try!(selects::select_all(&self.conn));
        let mut ret_skills: Vec<models::ConcreteSkill> = skills.iter()
            .map(|x| -> models::ConcreteSkill {
                models::ConcreteSkill::Skill(models::Skill {
                    name: x.name.clone(),
                    ability: x.ability.clone(),
                })
            })
            .collect();
        let sub_skills: Vec<structs::SubSkill> = try!(selects::select_all(&self.conn));
        let skill_constructors: Vec<structs::SkillConstructor> =
            try!(selects::select_all(&self.conn));
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
    let mut m: HashMap<i32, &'a structs::SkillConstructor> = HashMap::new();
    for s in s.iter() {
        m.insert(s.id, s);
    }
    return m;
}

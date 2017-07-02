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
                                                   queries::CHARACTER_SUB_SKILLS_SQL,
                                                   character.id));

        let class_skills: Vec<structs::ClassSkill> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));

        let class_sub_skills: Vec<structs::ClassSubSkill> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));

        let class_skill_constructors: Vec<structs::ClassSkillConstructor> =
            try!(selects::select_by_field(&self.conn, "class_id", class.id));

        let armor_piece: structs::ArmorPiece =
            try!(selects::exec_and_select_one_by_field(&self.conn,
                                                       queries::CHARACTER_ARMOR_PIECE_SQL,
                                                       creature.id));

        let option_creature_shield: Option<structs::CreatureShield> =
            try!(selects::select_optional_one_by_field(&self.conn, "creature_id", creature.id));

        let option_shield: Option<structs::Shield> =
            try!(selects::exec_and_select_optional_one_by_field(&self.conn,
                                                                queries::CHARACTER_SHIELD_SQL,
                                                                creature.id));

        let option_shield_damage: Option<structs::ShieldDamage> =
            try!(selects::exec_and_select_optional_one_by_field(&self.conn,
                                                                queries::SHIELD_DAMAGE_SQL,
                                                                creature.id));

        let weapons: Vec<structs::Weapon> = try!(selects::exec_and_select_by_field(&self.conn,
                                                   queries::CREATURE_WEAPON_SQL,
                                                   creature.id));

        let base_saving_throws: structs::ClassSavingThrows =
            try!(selects::exec_and_select_one_by_two_fields(&self.conn,
                                                            queries::BASE_SAVING_THROWS_SQL,
                                                            class.id,
                                                            creature.level));

        let armor_proficiency: structs::ClassArmorProficiency =
            try!(selects::exec_and_select_one_by_two_fields(&self.conn,
                                                            queries::CLASS_ARMOR_PROFICIENCY_SQL,
                                                            class.id,
                                                            creature.level));
        let items: Vec<structs::ExpandedCreatureItem> =
            try!(selects::exec_and_select_by_field(&self.conn,
                                                   queries::CREATURE_ITEMS_SQL,
                                                   creature.id));

        return Ok(convert::into_canonical_character(character,
                                                    creature,
                                                    abs,
                                                    class,
                                                    skills,
                                                    trained_skills,
                                                    sub_skills,
                                                    class_skills,
                                                    class_sub_skills,
                                                    class_skill_constructors,
                                                    armor_piece,
                                                    option_shield,
                                                    option_creature_shield,
                                                    option_shield_damage,
                                                    weapons,
                                                    base_saving_throws,
                                                    armor_proficiency,
                                                    items));
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

    pub fn get_armor_pieces(&self) -> Result<Vec<models::ArmorPiece>, error::Error> {
        let armor_pieces: Vec<structs::ArmorPiece> = try!(selects::select_all(&self.conn));
        return Ok(armor_pieces.iter().map(|x| x.into_canonical()).collect());
    }

    pub fn get_shields(&self) -> Result<Vec<models::Shield>, error::Error> {
        let shields: Vec<structs::Shield> = try!(selects::select_all(&self.conn));
        return Ok(shields.iter().map(|x| x.into_canonical()).collect());
    }

    pub fn get_weapons(&self) -> Result<Vec<models::Weapon>, error::Error> {
        let shields: Vec<structs::Weapon> = try!(selects::select_all(&self.conn));
        return Ok(shields.iter().map(|x| x.into_canonical()).collect());
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

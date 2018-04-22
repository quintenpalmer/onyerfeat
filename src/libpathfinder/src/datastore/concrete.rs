use std::collections::HashMap;

use postgres;

use libpathfinder_common::error;
use libpathfinder_common::FromRow;
use libpathfinder_common::TableNamer;

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
        let conn = try!(
            postgres::Connection::connect(c, postgres::TlsMode::None)
                .map_err(error::Error::PostgresConnect)
        );
        return Ok(Datastore { conn: conn });
    }

    pub fn get_character(&self, id: i32) -> Result<models::Character, error::Error> {
        let character: structs::Character = try!(selects::select_one_by_id(&self.conn, id));
        let creature: structs::Creature =
            try!(selects::select_one_by_id(&self.conn, character.creature_id));
        let abs: structs::AbilityScoreSet = try!(selects::select_one_by_id(
            &self.conn,
            creature.ability_score_set_id
        ));

        let character_classes: Vec<structs::ExpanededCharacterClass> =
            try!(selects::exec_and_select_by_field(
                &self.conn,
                queries::CHARACTER_CLASSES_SQL,
                character.id
            ));

        let languages: Vec<structs::ExpandedCreatureLanguage> =
            try!(selects::exec_and_select_by_field(
                &self.conn,
                queries::CREATURE_LANGUAGES_SQL,
                creature.id
            ));

        let skills: Vec<structs::Skill> = try!(selects::select_all(&self.conn));
        let trained_skills: Vec<structs::CharacterSkillChoice> = try!(selects::select_by_field(
            &self.conn,
            "character_id",
            character.id
        ));

        let sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice> =
            try!(selects::exec_and_select_by_field(
                &self.conn,
                queries::CHARACTER_SUB_SKILLS_SQL,
                character.id
            ));

        let mut class_skills: Vec<structs::ClassSkill> = Vec::new();
        for character_class in character_classes.iter() {
            class_skills.extend(try!(selects::select_by_field(
                &self.conn,
                "class_skill_set_id",
                character_class.class_skill_set_id
            )));
        }

        let mut class_sub_skills: Vec<structs::ClassSubSkill> = Vec::new();
        for character_class in character_classes.iter() {
            class_sub_skills.extend(try!(selects::select_by_field(
                &self.conn,
                "class_skill_set_id",
                character_class.class_skill_set_id
            )));
        }

        let mut class_skill_constructors: Vec<structs::ClassSkillConstructor> = Vec::new();
        for character_class in character_classes.iter() {
            class_skill_constructors.extend(try!(selects::select_by_field(
                &self.conn,
                "class_skill_set_id",
                character_class.class_skill_set_id
            )));
        }

        let armor_piece: structs::ExpandedArmorPieceInstance =
            try!(selects::exec_and_select_one_by_field(
                &self.conn,
                queries::CHARACTER_ARMOR_PIECE_INSTANCE_SQL,
                creature.id
            ));

        let option_creature_shield: Option<structs::CreatureShield> = try!(
            selects::select_optional_one_by_field(&self.conn, "creature_id", creature.id)
        );

        let option_shield: Option<structs::Shield> =
            try!(selects::exec_and_select_optional_one_by_field(
                &self.conn,
                queries::CHARACTER_SHIELD_SQL,
                creature.id
            ));

        let option_shield_damage: Option<structs::ShieldDamage> =
            try!(selects::exec_and_select_optional_one_by_field(
                &self.conn,
                queries::SHIELD_DAMAGE_SQL,
                creature.id
            ));

        let expanded_weapon_instances: Vec<structs::ExpandedWeaponInstance> =
            try!(selects::exec_and_select_by_field(
                &self.conn,
                queries::CREATURE_WEAPON_SQL,
                creature.id
            ));

        let mut base_saving_throws_list: Vec<structs::ClassSavingThrows> = Vec::new();
        for character_class in character_classes.iter() {
            base_saving_throws_list.push(try!(selects::exec_and_select_one_by_two_fields(
                &self.conn,
                queries::BASE_SAVING_THROWS_SQL,
                character_class.class_id,
                character_class.level
            )));
        }

        let mut class_bonuses_list: Vec<structs::ClassBonuses> = Vec::new();
        for character_class in character_classes.iter() {
            class_bonuses_list.push(try!(selects::exec_and_select_one_by_two_fields(
                &self.conn,
                queries::CLASS_BONUSES_SQL,
                character_class.class_bonus_set_id,
                character_class.level
            )));
        }

        let items: Vec<structs::ExpandedCreatureItem> = try!(selects::exec_and_select_by_field(
            &self.conn,
            queries::CREATURE_ITEMS_SQL,
            creature.id
        ));

        return Ok(convert::into_canonical_character(
            character,
            creature,
            abs,
            character_classes,
            languages,
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
            expanded_weapon_instances,
            base_saving_throws_list,
            class_bonuses_list,
            items,
        ));
    }

    pub fn get_skills(&self) -> Result<Vec<models::ConcreteSkill>, error::Error> {
        let skills: Vec<structs::Skill> = try!(selects::select_all(&self.conn));
        let mut ret_skills: Vec<models::ConcreteSkill> = skills
            .iter()
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

    pub fn insert_new_character_item(
        &self,
        exp_char_item: models::CreatureItem,
    ) -> Result<models::CreatureItem, error::Error> {
        let txn = try!(self.conn.transaction().map_err(error::Error::Postgres));
        match insert_character_item(&txn, exp_char_item) {
            Ok(res) => {
                let _ = txn.commit();
                Ok(res)
            }
            Err(e) => {
                txn.set_rollback();
                Err(e)
            }
        }
    }
}

fn insert_character_item(
    txn: &postgres::transaction::Transaction,
    exp_char_item: models::CreatureItem,
) -> Result<models::CreatureItem, error::Error> {
    let existing_item: Option<structs::Item> = try!(selects::select_optional_one_by_field(
        txn,
        "name",
        exp_char_item.name.clone()
    ));
    let item_to_insert = match existing_item {
        Some(item) => item,
        None => try!(insert_raw_item(
            txn,
            exp_char_item.name.clone(),
            exp_char_item.description.clone()
        )),
    };

    let char_item = try!(insert_raw_char_item(
        txn,
        item_to_insert.id,
        exp_char_item.creature_id,
        exp_char_item.count
    ));

    return Ok(models::CreatureItem {
        id: char_item.id,
        creature_id: char_item.creature_id,
        name: item_to_insert.name.clone(),
        description: item_to_insert.description.clone(),
        count: char_item.count,
    });
}

fn insert_raw_item(
    txn: &postgres::transaction::Transaction,
    name: String,
    description: String,
) -> Result<structs::Item, error::Error> {
    let stmt = try!(
        txn.prepare(queries::INSERT_ITEM_SQL)
            .map_err(error::Error::Postgres)
    );
    let rows = try!(
        stmt.query(&[&name, &description])
            .map_err(error::Error::Postgres)
    );
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne(
            structs::Item::get_table_name().to_string(),
        ));
    }
    let row = rows.get(0);
    return structs::Item::parse_row(row);
}

fn insert_raw_char_item(
    txn: &postgres::transaction::Transaction,
    item_id: i32,
    creature_id: i32,
    count: i32,
) -> Result<structs::CreatureItem, error::Error> {
    let stmt = try!(
        txn.prepare(queries::INSERT_CHARACTER_ITEM_SQL)
            .map_err(error::Error::Postgres)
    );
    let rows = try!(
        stmt.query(&[&creature_id, &item_id, &count])
            .map_err(error::Error::Postgres)
    );
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne(
            structs::CreatureItem::get_table_name().to_string(),
        ));
    }
    let row = rows.get(0);
    return structs::CreatureItem::parse_row(row);
}

fn skill_constructor_map<'a>(
    s: &'a Vec<structs::SkillConstructor>,
) -> HashMap<i32, &'a structs::SkillConstructor> {
    let mut m: HashMap<i32, &'a structs::SkillConstructor> = HashMap::new();
    for s in s.iter() {
        m.insert(s.id, s);
    }
    return m;
}

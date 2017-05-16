use postgres;

use libpathfinder_common::error;

use models;

#[derive(TableNamer)]
#[table_namer(table_name = "characters")]
#[derive(FromRow)]
pub struct Character {
    pub id: i32,
    pub player_name: String,
    pub class_id: i32,
    pub creature_id: i32,
}

#[derive(TableNamer)]
#[table_namer(table_name = "classes")]
#[derive(FromRow)]
pub struct Class {
    pub id: i32,
    pub name: String,
}

#[derive(TableNamer)]
#[table_namer(table_name = "creatures")]
#[derive(FromRow)]
pub struct Creature {
    pub id: i32,
    pub name: String,
    pub alignment_order: models::AlignmentOrder,
    pub alignment_morality: models::AlignmentMorality,
    pub ability_score_set_id: i32,
    pub race: String,
    pub deity: Option<String>,
    pub age: i32,
    pub size: models::Size,
    pub max_hit_points: i32,
    pub current_hit_points: i32,
}

#[derive(TableNamer)]
#[table_namer(table_name = "ability_score_sets")]
#[derive(FromRow)]
#[allow(dead_code)]
pub struct AbilityScoreSet {
    id: i32,
    pub str: i32,
    pub dex: i32,
    pub con: i32,
    pub int: i32,
    pub wis: i32,
    pub cha: i32,
}

impl AbilityScoreSet {
    pub fn get_ability_mod(&self, ability_name: models::AbilityName) -> i32 {
        calc_ability_modifier(match ability_name {
            models::AbilityName::Str => self.str,
            models::AbilityName::Dex => self.dex,
            models::AbilityName::Con => self.con,
            models::AbilityName::Int => self.int,
            models::AbilityName::Wis => self.wis,
            models::AbilityName::Cha => self.cha,
        })
    }
}

#[derive(TableNamer)]
#[table_namer(table_name = "skills")]
#[derive(FromRow)]
pub struct Skill {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

#[derive(TableNamer)]
#[table_namer(table_name = "skill_constructors")]
#[derive(FromRow)]
pub struct SkillConstructor {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

#[derive(TableNamer)]
#[table_namer(table_name = "sub_skills")]
#[derive(FromRow)]
pub struct SubSkill {
    pub id: i32,
    pub name: String,
    pub skill_constructor_id: i32,
}

#[derive(TableNamer)]
#[table_namer(table_name = "character_skill_choices")]
#[derive(FromRow)]
pub struct CharacterSkillChoice {
    pub id: i32,
    pub character_id: i32,
    pub skill_id: i32,
    pub count: i32,
}

#[derive(TableNamer)]
#[table_namer(table_name = "character_sub_skill_choices")]
#[derive(FromRow)]
pub struct CharacterSubSkillChoice {
    pub id: i32,
    pub character_id: i32,
    pub sub_skill_id: i32,
}

#[derive(FromRow)]
pub struct AugmentedCharacterSubSkillChoice {
    pub id: i32,
    pub skill_constructor_id: i32,
    pub sub_skill_id: i32,
    pub count: i32,
    pub name: String,
    pub sub_name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

#[derive(TableNamer)]
#[table_namer(table_name = "class_skills")]
#[derive(FromRow)]
pub struct ClassSkill {
    pub id: i32,
    pub class_id: i32,
    pub skill_id: i32,
}


#[derive(TableNamer)]
#[table_namer(table_name = "class_sub_skills")]
#[derive(FromRow)]
pub struct ClassSubSkill {
    pub id: i32,
    pub class_id: i32,
    pub sub_skill_id: i32,
}

#[derive(TableNamer)]
#[table_namer(table_name = "class_skill_constructors")]
#[derive(FromRow)]
pub struct ClassSkillConstructor {
    pub id: i32,
    pub class_id: i32,
    pub skill_constructor_id: i32,
}

pub fn calc_ability_modifier(i: i32) -> i32 {
    let rounded = if i % 2 == 0 {
        i
    } else if i > 0 {
        i - 1
    } else {
        i + 1
    };
    return (rounded - 10) / 2;
}

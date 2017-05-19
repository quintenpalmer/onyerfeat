use postgres;

use libpathfinder_common::error;

use models;

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "characters")]
pub struct Character {
    pub id: i32,
    pub player_name: String,
    pub class_id: i32,
    pub creature_id: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "classes")]
pub struct Class {
    pub id: i32,
    pub name: String,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creatures")]
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
    pub nonlethal_damage: i32,
    pub base_attack_bonus: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "ability_score_sets")]
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

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "skills")]
pub struct Skill {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "skill_constructors")]
pub struct SkillConstructor {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "sub_skills")]
pub struct SubSkill {
    pub id: i32,
    pub name: String,
    pub skill_constructor_id: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "character_skill_choices")]
pub struct CharacterSkillChoice {
    pub id: i32,
    pub character_id: i32,
    pub skill_id: i32,
    pub count: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "character_sub_skill_choices")]
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

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "class_skills")]
pub struct ClassSkill {
    pub id: i32,
    pub class_id: i32,
    pub skill_id: i32,
}


#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "class_sub_skills")]
pub struct ClassSubSkill {
    pub id: i32,
    pub class_id: i32,
    pub sub_skill_id: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "class_skill_constructors")]
pub struct ClassSkillConstructor {
    pub id: i32,
    pub class_id: i32,
    pub skill_constructor_id: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "armor_pieces")]
pub struct ArmorPiece {
    pub id: i32,
    pub armor_class: String,
    pub name: String,
    pub armor_bonus: i32,
    pub max_dex_bonus: i32,
    pub armor_check_penalty: i32,
    pub arcane_spell_failure_chance: i32,
    pub fast_speed: i32,
    pub slow_speed: i32,
    pub medium_weight: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "shields")]
pub struct Shield {
    pub id: i32,
    pub name: String,
    pub ac_bonus: i32,
    pub max_dex: Option<i32>,
    pub skill_penalty: i32,
    pub arcane_spell_failure_chance: i32,
    pub weight: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creature_armor_pieces")]
pub struct CreatureArmorPiece {
    pub id: i32,
    pub creature_id: i32,
    pub armor_pieces_id: i32,
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

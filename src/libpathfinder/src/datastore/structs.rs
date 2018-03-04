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
    pub level: i32,
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

#[derive(FromRow)]
pub struct ExpandedArmorPieceInstance {
    pub armor_class: String,
    pub name: String,
    pub armor_bonus: i32,
    pub max_dex_bonus: i32,
    pub armor_check_penalty: i32,
    pub arcane_spell_failure_chance: i32,
    pub fast_speed: i32,
    pub slow_speed: i32,
    pub medium_weight: i32,
    pub is_masterwork: bool,
    pub special: Option<String>,
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
    pub size_style: Option<models::WeaponSizeStyle>,
}

#[derive(FromRow)]
pub struct ShieldDamage {
    pub shield_name: String,
    pub id: i32,
    pub size_style: models::WeaponSizeStyle,
    pub spiked: bool,
    pub small_damage: models::DiceDamage,
    pub medium_damage: models::DiceDamage,
    pub critical: models::CriticalDamage,
    pub range: Option<i32>,
    pub weight: i32,
    pub damage_type: models::PhysicalDamageType,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creature_armor_pieces")]
pub struct CreatureArmorPiece {
    pub id: i32,
    pub creature_id: i32,
    pub armor_pieces_id: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creature_shields")]
pub struct CreatureShield {
    pub id: i32,
    pub creature_id: i32,
    pub shield_id: i32,
    pub has_spikes: bool,
    pub is_masterwork: bool,
    pub special: Option<String>,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "class_bonuses")]
pub struct ClassBonuses {
    pub id: i32,
    pub class_id: i32,
    pub level: i32,
    pub fortitude: i32,
    pub reflex: i32,
    pub will: i32,
    pub cha_bonus: bool,
    pub ac_penalty_reduction: i32,
    pub max_dex_bonus: i32,
    pub natural_armor_bonus: i32,
    pub str_dex_bonus: i32,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "weapons")]
pub struct Weapon {
    pub id: i32,
    pub name: String,
    pub training_type: models::WeaponTrainingType,
    pub size_style: models::WeaponSizeStyle,
    pub cost: i32,
    pub small_damage: models::DiceDamage,
    pub medium_damage: models::DiceDamage,
    pub critical: models::CriticalDamage,
    pub range: Option<i32>,
    pub weight: i32,
    pub damage_type: models::PhysicalDamageType,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "weapon_instances")]
pub struct WeaponInstance {
    pub id: i32,
    pub weapon_id: i32,
    pub name: Option<String>,
    pub is_masterwork: bool,
    pub special: Option<String>,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creature_weapons")]
pub struct ExpandedWeaponInstance {
    pub name: String,
    pub training_type: models::WeaponTrainingType,
    pub size_style: models::WeaponSizeStyle,
    pub cost: i32,
    pub small_damage: models::DiceDamage,
    pub medium_damage: models::DiceDamage,
    pub critical: models::CriticalDamage,
    pub range: Option<i32>,
    pub weight: i32,
    pub damage_type: models::PhysicalDamageType,
    pub weapon_instance_name: Option<String>,
    pub is_masterwork: bool,
    pub special: Option<String>,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "items")]
pub struct Item {
    pub id: i32,
    pub name: String,
    pub description: String,
}

#[derive(TableNamer, FromRow)]
#[table_namer(table_name = "creature_items")]
pub struct CreatureItem {
    pub id: i32,
    pub item_id: i32,
    pub creature_id: i32,
    pub count: i32,
}

#[derive(FromRow)]
pub struct ExpandedCreatureItem {
    pub id: i32,
    pub creature_id: i32,
    pub name: String,
    pub description: String,
    pub count: i32,
}

#[derive(FromRow)]
pub struct ExpandedCreatureLanguage {
    pub creature_id: i32,
    pub name: String,
}

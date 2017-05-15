use std::collections::HashMap;
use std::str;
use std::error as stderror;

use models;
use postgres;

use libpathfinder_common::error;

#[derive(TableNamer)]
#[table_namer(table_name = "characters")]
#[derive(FromRow)]
pub struct Character {
    pub id: i32,
    pub player_name: String,
    pub class_id: i32,
    pub creature_id: i32,
}

impl Character {
    pub fn into_canonical(&self,
                          creature: Creature,
                          abs: AbilityScoreSet,
                          class: Class,
                          skills: Vec<Skill>,
                          skill_choices: Vec<CharacterSkillChoice>,
                          sub_skills: Vec<AugmentedCharacterSubSkillChoice>)
                          -> models::Character {
        let character_skills = get_character_skills(skills, skill_choices, sub_skills, &abs);
        return models::Character {
            id: self.id,
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
            player_name: self.player_name.clone(),
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
            skills: character_skills,
        };
    }
}

fn get_character_skills(skills: Vec<Skill>,
                        skill_choices: Vec<CharacterSkillChoice>,
                        sub_skills: Vec<AugmentedCharacterSubSkillChoice>,
                        abs: &AbilityScoreSet)
                        -> Vec<models::CharacterSkill> {
    let mut ret_skills = Vec::new();
    let choice_map = skill_choice_map(&skill_choices);
    for skill in skills.iter() {
        let count = match choice_map.get(&skill.id) {
            Some(choice) => choice.count,
            None => 0,
        };
        let ability_mod = abs.get_ability_mod(skill.ability.clone());
        let total = count + ability_mod;
        ret_skills.push(models::CharacterSkill {
            name: skill.name.clone(),
            sub_name: None,
            total: total,
            ability: skill.ability.clone(),
            ability_mod: ability_mod,
            count: count,
        });
    }
    for sub_skill in sub_skills.iter() {
        let count = sub_skill.count;
        let ability_mod = abs.get_ability_mod(sub_skill.ability.clone());
        let total = count + ability_mod;
        ret_skills.push(models::CharacterSkill {
            name: sub_skill.name.clone(),
            sub_name: Some(sub_skill.sub_name.clone()),
            total: total,
            ability: sub_skill.ability.clone(),
            ability_mod: ability_mod,
            count: count,
        });
    }
    return ret_skills;
}

fn skill_choice_map<'a>(s: &'a Vec<CharacterSkillChoice>)
                        -> HashMap<i32, &'a CharacterSkillChoice> {
    let mut m = HashMap::new();
    for s in s.iter() {
        m.insert(s.skill_id, s);
    }
    return m;
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
    pub count: i32,
    pub name: String,
    pub sub_name: String,
    pub trained_only: bool,
    pub ability: models::AbilityName,
}

impl postgres::types::FromSql for models::AbilityName {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "str" => Ok(models::AbilityName::Str),
                    "dex" => Ok(models::AbilityName::Dex),
                    "con" => Ok(models::AbilityName::Con),
                    "int" => Ok(models::AbilityName::Int),
                    "wis" => Ok(models::AbilityName::Wis),
                    "cha" => Ok(models::AbilityName::Cha),
                    _ => Err(Box::new(error::Error::ParseError {})),
                }
            }
            _ => Err(Box::new(error::Error::ParseError {})),
        }
    }

    fn accepts(ty: &postgres::types::Type) -> bool {
        match ty {
            &postgres::types::Type::Text => true,
            _ => false,
        }
    }
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
                    _ => Err(Box::new(error::Error::ParseError {})),
                }
            }
            _ => Err(Box::new(error::Error::ParseError {})),
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
                    _ => Err(Box::new(error::Error::ParseError {})),
                }
            }
            _ => Err(Box::new(error::Error::ParseError {})),
        }
    }

    fn accepts(ty: &postgres::types::Type) -> bool {
        match ty {
            &postgres::types::Type::Text => true,
            _ => false,
        }
    }
}

impl postgres::types::FromSql for models::Size {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "colossal" => Ok(models::Size::Colossal),
                    "gargantuan" => Ok(models::Size::Gargantuan),
                    "huge" => Ok(models::Size::Huge),
                    "large" => Ok(models::Size::Large),
                    "medium" => Ok(models::Size::Medium),
                    "small" => Ok(models::Size::Small),
                    "tiny" => Ok(models::Size::Tiny),
                    "diminutive" => Ok(models::Size::Diminutive),
                    "fine" => Ok(models::Size::Fine),
                    _ => Err(Box::new(error::Error::ParseError {})),
                }
            }
            _ => Err(Box::new(error::Error::ParseError {})),
        }
    }

    fn accepts(ty: &postgres::types::Type) -> bool {
        match ty {
            &postgres::types::Type::Text => true,
            _ => false,
        }
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

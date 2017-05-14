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

#[derive(TableNamer)]
#[table_namer(table_name = "skills")]
#[derive(FromRow)]
pub struct Skill {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
}

#[derive(TableNamer)]
#[table_namer(table_name = "skill_constructors")]
#[derive(FromRow)]
pub struct SkillConstructor {
    pub id: i32,
    pub name: String,
    pub trained_only: bool,
}

#[derive(TableNamer)]
#[table_namer(table_name = "sub_skills")]
#[derive(FromRow)]
pub struct SubSkill {
    pub id: i32,
    pub name: String,
    pub skill_constructor_id: i32,
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

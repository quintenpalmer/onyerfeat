use std::error as stderror;

use std::str;

use postgres;

use libpathfinder_common::error;

use models;

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

impl postgres::types::FromSql for models::WeaponTrainingType {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "simple" => Ok(models::WeaponTrainingType::Simple),
                    "martial" => Ok(models::WeaponTrainingType::Martial),
                    "exotic" => Ok(models::WeaponTrainingType::Exotic),
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

impl postgres::types::FromSql for models::WeaponSizeStyle {
    fn from_sql(ty: &postgres::types::Type,
                raw: &[u8])
                -> Result<Self, Box<stderror::Error + Send + Sync>> {
        match ty {
            &postgres::types::Type::Text => {
                match try!(str::from_utf8(raw)) {
                    "unarmed_melee" => Ok(models::WeaponSizeStyle::UnarmedMelee),
                    "light_melee" => Ok(models::WeaponSizeStyle::LightMelee),
                    "one_handed_melee" => Ok(models::WeaponSizeStyle::OneHandedMelee),
                    "two_handed_melee" => Ok(models::WeaponSizeStyle::TwoHandedMelee),
                    "ranged" => Ok(models::WeaponSizeStyle::Ranged),
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

use std::collections::{HashMap, HashSet};

use models;

use datastore::structs;

pub fn into_canonical_character(character: structs::Character,
                                creature: structs::Creature,
                                abs: structs::AbilityScoreSet,
                                class: structs::Class,
                                skills: Vec<structs::Skill>,
                                skill_choices: Vec<structs::CharacterSkillChoice>,
                                sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice>,
                                class_skills: Vec<structs::ClassSkill>,
                                class_sub_skills: Vec<structs::ClassSubSkill>,
                                class_skill_constructors: Vec<structs::ClassSkillConstructor>,
                                armor_piece: structs::ArmorPiece,
                                optional_shield: Option<structs::Shield>,
                                base_saving_throws: structs::ClassSavingThrows)
                                -> models::Character {
    let ability_score_model = models::AbilityScoreInfo {
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
    };
    let size_mod = creature.size.get_modifier();
    let character_skills = get_character_skills(skills,
                                                skill_choices,
                                                sub_skills,
                                                class_skills,
                                                class_sub_skills,
                                                class_skill_constructors,
                                                &ability_score_model,
                                                &armor_piece,
                                                &optional_shield);
    let armor_class = {
        let dex_mod = ability_score_model.dex.modifier;
        let base = 10;
        let armor_ac = armor_piece.armor_bonus;
        let shield_ac = match optional_shield {
            Some(ref shield) => shield.ac_bonus,
            None => 0,
        };
        let armor_class = models::ArmorClass {
            total: dex_mod + base + armor_ac + shield_ac + size_mod,
            base: base,
            dex: dex_mod,
            armor_ac: armor_ac,
            size_mod: size_mod,
            deflection_mod: 0,
            dodge_mod: 0,
            shield_ac: shield_ac,
            natural_armor: 0,
        };
        armor_class
    };
    return models::Character {
        id: character.id,
        level: creature.level,
        ability_scores: models::AbilityScoreSet {
            str: abs.str,
            dex: abs.dex,
            con: abs.con,
            int: abs.int,
            wis: abs.wis,
            cha: abs.cha,
        },
        meta_information: models::MetaInformation {
            name: creature.name,
            player_name: character.player_name.clone(),
            alignment: models::Alignment {
                morality: creature.alignment_morality,
                order: creature.alignment_order,
            },
            class: class.name,
            race: creature.race,
            age: creature.age,
            deity: creature.deity,
            size: creature.size,
        },
        combat_numbers: models::CombatNumbers {
            max_hit_points: creature.max_hit_points,
            current_hit_points: creature.current_hit_points,
            nonlethal_damage: creature.nonlethal_damage,
            armor_class: armor_class,
            base_attack_bonus: creature.base_attack_bonus,
            saving_throws: base_saving_throws.into_canonical(&ability_score_model),
            combat_maneuvers: build_combat_maneuvers(&ability_score_model,
                                                     creature.base_attack_bonus,
                                                     size_mod),
        },
        armor_piece: armor_piece.into_canonical(),
        shield: match optional_shield {
            Some(x) => Some(x.into_canonical()),
            None => None,
        },
        skills: character_skills,
        ability_score_info: ability_score_model,
    };
}

fn get_character_skills(skills: Vec<structs::Skill>,
                        skill_choices: Vec<structs::CharacterSkillChoice>,
                        sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice>,
                        class_skills: Vec<structs::ClassSkill>,
                        class_sub_skills: Vec<structs::ClassSubSkill>,
                        class_skill_constructors: Vec<structs::ClassSkillConstructor>,
                        abs: &models::AbilityScoreInfo,
                        armor_piece: &structs::ArmorPiece,
                        optional_shield: &Option<structs::Shield>)
                        -> Vec<models::CharacterSkill> {
    let mut ret_skills = Vec::new();
    let choice_map = skill_choice_map(&skill_choices);
    let class_map = class_skill_map(&class_skills);
    let class_sub_set = class_sub_skill_set(&class_sub_skills);
    let class_constructor_set = class_skill_constructor_set(&class_skill_constructors);
    let shield_penalty = match *optional_shield {
        Some(ref s) => s.skill_penalty,
        None => 0,
    };
    for skill in skills.iter() {
        let armor_penalty = if is_armor_penalized(skill.ability.clone()) {
            Some(armor_piece.armor_check_penalty + shield_penalty)
        } else {
            None
        };
        let count = match choice_map.get(&skill.id) {
            Some(choice) => choice.count,
            None => 0,
        };
        let is_class_skill = class_map.contains_key(&skill.id);
        let class_mod = if is_class_skill && count > 0 { 3 } else { 0 };
        let ability_mod = abs.get_ability_mod(skill.ability.clone());
        let total = count + ability_mod + class_mod + armor_penalty.unwrap_or(0);
        ret_skills.push(models::CharacterSkill {
            name: skill.name.clone(),
            sub_name: None,
            total: total,
            ability: skill.ability.clone(),
            ability_mod: ability_mod,
            is_class_skill: is_class_skill,
            class_mod: class_mod,
            count: count,
            armor_check_penalty: armor_penalty,
        });
    }
    for sub_skill in sub_skills.iter() {
        let armor_penalty = if is_armor_penalized(sub_skill.ability.clone()) {
            Some(armor_piece.armor_check_penalty + shield_penalty)
        } else {
            None
        };
        let count = sub_skill.count;
        let is_class_skill = class_sub_set.contains(&sub_skill.sub_skill_id) ||
                             class_constructor_set.contains(&sub_skill.skill_constructor_id);
        let class_mod = if is_class_skill && count > 0 { 3 } else { 0 };
        let ability_mod = abs.get_ability_mod(sub_skill.ability.clone());
        let total = count + ability_mod + class_mod + armor_penalty.unwrap_or(0);
        ret_skills.push(models::CharacterSkill {
            name: sub_skill.name.clone(),
            sub_name: Some(sub_skill.sub_name.clone()),
            total: total,
            ability: sub_skill.ability.clone(),
            ability_mod: ability_mod,
            is_class_skill: is_class_skill,
            class_mod: class_mod,
            count: count,
            armor_check_penalty: armor_penalty,
        });
    }
    return ret_skills;
}

fn class_skill_constructor_set<'a>(s: &'a Vec<structs::ClassSkillConstructor>) -> HashSet<i32> {
    let mut m = HashSet::new();
    for s in s.iter() {
        m.insert(s.skill_constructor_id);
    }
    return m;
}

fn class_sub_skill_set<'a>(s: &'a Vec<structs::ClassSubSkill>) -> HashSet<i32> {
    let mut m = HashSet::new();
    for s in s.iter() {
        m.insert(s.sub_skill_id);
    }
    return m;
}

fn class_skill_map<'a>(s: &'a Vec<structs::ClassSkill>) -> HashMap<i32, &'a structs::ClassSkill> {
    let mut m = HashMap::new();
    for s in s.iter() {
        m.insert(s.skill_id, s);
    }
    return m;
}

fn skill_choice_map<'a>(s: &'a Vec<structs::CharacterSkillChoice>)
                        -> HashMap<i32, &'a structs::CharacterSkillChoice> {
    let mut m = HashMap::new();
    for s in s.iter() {
        m.insert(s.skill_id, s);
    }
    return m;
}

impl structs::ArmorPiece {
    pub fn into_canonical(&self) -> models::ArmorPiece {
        models::ArmorPiece {
            armor_class: self.armor_class.clone(),
            name: self.name.clone(),
            armor_bonus: self.armor_bonus,
            max_dex_bonus: self.max_dex_bonus,
            armor_check_penalty: self.armor_check_penalty,
            arcane_spell_failure_chance: self.arcane_spell_failure_chance,
            fast_speed: self.fast_speed,
            slow_speed: self.slow_speed,
            medium_weight: self.medium_weight,
        }
    }
}

impl structs::Shield {
    pub fn into_canonical(&self) -> models::Shield {
        models::Shield {
            name: self.name.clone(),
            ac_bonus: self.ac_bonus,
            max_dex: self.max_dex,
            skill_penalty: self.skill_penalty,
            arcane_spell_failure_chance: self.arcane_spell_failure_chance,
            weight: self.weight,
        }
    }
}

impl structs::Weapon {
    pub fn into_canonical(&self) -> models::Weapon {
        models::Weapon {
            name: self.name.clone(),
            training_type: self.training_type.clone(),
            size_style: self.size_style.clone(),
            cost: self.cost,
            small_damage: self.small_damage.clone(),
            medium_damage: self.medium_damage.clone(),
            critical: self.critical.clone(),
            range: self.range,
            weight: self.weight,
            damage_type: self.damage_type.clone(),
        }
    }
}

impl structs::ClassSavingThrows {
    pub fn into_canonical(&self, abs: &models::AbilityScoreInfo) -> models::SavingThrows {
        models::SavingThrows {
            fortitude: build_saving_throw(self.fortitude,
                                          abs.con.modifier,
                                          models::AbilityName::Con),
            reflex: build_saving_throw(self.reflex, abs.dex.modifier, models::AbilityName::Dex),
            will: build_saving_throw(self.will, abs.wis.modifier, models::AbilityName::Wis),
        }
    }
}

fn build_saving_throw(class_base: i32,
                      ability_mod: i32,
                      ability_name: models::AbilityName)
                      -> models::SavingThrow {
    let total = class_base + ability_mod;
    return models::SavingThrow {
        total: total,
        base: class_base,
        ability_mod: ability_mod,
        ability_name: ability_name,
    };
}

fn build_combat_maneuvers(abilities: &models::AbilityScoreInfo,
                          base_attack_bonus: i32,
                          size_mod: i32)
                          -> models::CombatManeuvers {
    let bonus = {
        let str_mod = abilities.str.modifier;
        let total = str_mod + base_attack_bonus + size_mod;
        models::CombatManeuverBonus {
            total: total,
            str: str_mod,
            base_attack_bonus: base_attack_bonus,
            size_mod: size_mod,
        }
    };
    let defense = {
        let base = 10;
        let str_mod = abilities.str.modifier;
        let dex_mod = abilities.dex.modifier;
        let total = base + str_mod + dex_mod + base_attack_bonus + size_mod;
        models::CombatManeuverDefense {
            total: total,
            base: base,
            str: str_mod,
            dex: dex_mod,
            base_attack_bonus: base_attack_bonus,
            size_mod: size_mod,
        }
    };
    models::CombatManeuvers {
        bonus: bonus,
        defense: defense,
    }
}

fn is_armor_penalized(ability: models::AbilityName) -> bool {
    match ability {
        models::AbilityName::Str => true,
        models::AbilityName::Dex => true,
        _ => false,
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

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
                                class_skill_constructors: Vec<structs::ClassSkillConstructor>)
                                -> models::Character {
    let character_skills = get_character_skills(skills,
                                                skill_choices,
                                                sub_skills,
                                                class_skills,
                                                class_sub_skills,
                                                class_skill_constructors,
                                                &abs);
    return models::Character {
        id: character.id,
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
                modifier: structs::calc_ability_modifier(abs.str),
            },
            dex: models::ScoreAndMofidier {
                score: abs.dex,
                modifier: structs::calc_ability_modifier(abs.dex),
            },
            con: models::ScoreAndMofidier {
                score: abs.con,
                modifier: structs::calc_ability_modifier(abs.con),
            },
            int: models::ScoreAndMofidier {
                score: abs.int,
                modifier: structs::calc_ability_modifier(abs.int),
            },
            wis: models::ScoreAndMofidier {
                score: abs.wis,
                modifier: structs::calc_ability_modifier(abs.wis),
            },
            cha: models::ScoreAndMofidier {
                score: abs.cha,
                modifier: structs::calc_ability_modifier(abs.cha),
            },
        },
        alignment: models::Alignment {
            morality: creature.alignment_morality,
            order: creature.alignment_order,
        },
        player_name: character.player_name.clone(),
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
            nonlethal_damage: creature.nonlethal_damage,
        },
        skills: character_skills,
    };
}

fn get_character_skills(skills: Vec<structs::Skill>,
                        skill_choices: Vec<structs::CharacterSkillChoice>,
                        sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice>,
                        class_skills: Vec<structs::ClassSkill>,
                        class_sub_skills: Vec<structs::ClassSubSkill>,
                        class_skill_constructors: Vec<structs::ClassSkillConstructor>,
                        abs: &structs::AbilityScoreSet)
                        -> Vec<models::CharacterSkill> {
    let mut ret_skills = Vec::new();
    let choice_map = skill_choice_map(&skill_choices);
    let class_map = class_skill_map(&class_skills);
    let class_sub_set = class_sub_skill_set(&class_sub_skills);
    let class_constructor_set = class_skill_constructor_set(&class_skill_constructors);
    for skill in skills.iter() {
        let count = match choice_map.get(&skill.id) {
            Some(choice) => choice.count,
            None => 0,
        };
        let is_class_skill = class_map.contains_key(&skill.id);
        let class_mod = if is_class_skill && count > 0 { 3 } else { 0 };
        let ability_mod = abs.get_ability_mod(skill.ability.clone());
        let total = count + ability_mod + class_mod;
        ret_skills.push(models::CharacterSkill {
            name: skill.name.clone(),
            sub_name: None,
            total: total,
            ability: skill.ability.clone(),
            ability_mod: ability_mod,
            is_class_skill: is_class_skill,
            class_mod: class_mod,
            count: count,
        });
    }
    for sub_skill in sub_skills.iter() {
        let count = sub_skill.count;
        let is_class_skill = class_sub_set.contains(&sub_skill.sub_skill_id) ||
                             class_constructor_set.contains(&sub_skill.skill_constructor_id);
        let class_mod = if is_class_skill && count > 0 { 3 } else { 0 };
        let ability_mod = abs.get_ability_mod(sub_skill.ability.clone());
        let total = count + ability_mod + class_mod;
        ret_skills.push(models::CharacterSkill {
            name: sub_skill.name.clone(),
            sub_name: Some(sub_skill.sub_name.clone()),
            total: total,
            ability: sub_skill.ability.clone(),
            ability_mod: ability_mod,
            is_class_skill: is_class_skill,
            class_mod: class_mod,
            count: count,
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
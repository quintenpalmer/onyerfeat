use std::collections::{HashMap, HashSet};

use models;

use datastore::structs;

pub fn into_canonical_character(
    character: structs::Character,
    creature: structs::Creature,
    abs: structs::AbilityScoreSet,
    class: structs::Class,
    languages: Vec<structs::ExpandedCreatureLanguage>,
    skills: Vec<structs::Skill>,
    skill_choices: Vec<structs::CharacterSkillChoice>,
    sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice>,
    class_skills: Vec<structs::ClassSkill>,
    class_sub_skills: Vec<structs::ClassSubSkill>,
    class_skill_constructors: Vec<structs::ClassSkillConstructor>,
    armor_piece: structs::ExpandedArmorPieceInstance,
    optional_shield: Option<structs::Shield>,
    optional_creature_shield: Option<structs::CreatureShield>,
    optional_shield_damage: Option<structs::ShieldDamage>,
    weapons: Vec<structs::ExpandedWeaponInstance>,
    base_saving_throws: structs::ClassBonuses,
    items: Vec<structs::ExpandedCreatureItem>,
) -> models::Character {
    let ability_score_model = models::AbilityScoreInfo {
        str: models::ScoreAndMofidier {
            score: abs.str + base_saving_throws.str_dex_bonus,
            modifier: calc_ability_modifier(abs.str),
        },
        dex: models::ScoreAndMofidier {
            score: abs.dex + base_saving_throws.str_dex_bonus,
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
    let character_skills = get_character_skills(
        skills,
        skill_choices,
        sub_skills,
        class_skills,
        class_sub_skills,
        class_skill_constructors,
        &base_saving_throws,
        &ability_score_model,
        &armor_piece,
        &optional_shield,
        &optional_creature_shield,
    );
    let armor_class = {
        let dex_mod = ability_score_model.dex.modifier;
        let base = 10;
        let armor_ac = armor_piece.armor_bonus;
        let shield_ac = match optional_shield {
            Some(ref shield) => shield.ac_bonus,
            None => 0,
        };
        let misc = base_saving_throws.natural_armor_bonus;
        let armor_class = models::ArmorClass {
            total: dex_mod + base + armor_ac + shield_ac + misc + size_mod,
            base: base,
            dex: dex_mod,
            armor_ac: armor_ac,
            size_mod: size_mod,
            deflection_mod: 0,
            dodge_mod: 0,
            shield_ac: shield_ac,
            misc: misc,
            natural_armor: 0,
        };
        armor_class
    };
    let full_weapons = weapons.iter().map(|x| x.into_canonical()).collect();
    let mut combat_weapons = build_combat_weapon_stats(
        &full_weapons,
        &creature.size,
        creature.base_attack_bonus,
        &ability_score_model,
    );
    match optional_shield_damage {
        Some(shield_damage) => {
            let mut shield_as_weapon = build_combat_weapon_stats(
                &vec![shield_damage.into_canonical_weapon()],
                &creature.size,
                creature.base_attack_bonus,
                &ability_score_model,
            );
            combat_weapons.append(&mut shield_as_weapon)
        }
        None => (),
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
        combat_numbers: models::CombatNumbers {
            max_hit_points: creature.max_hit_points,
            current_hit_points: creature.current_hit_points,
            nonlethal_damage: creature.nonlethal_damage,
            armor_class: armor_class,
            base_attack_bonus: creature.base_attack_bonus,
            saving_throws: base_saving_throws.into_canonical(&ability_score_model),
            combat_maneuvers: build_combat_maneuvers(
                &ability_score_model,
                creature.base_attack_bonus,
                size_mod,
            ),
        },
        armor_piece: armor_piece.into_canonical(),
        shield: match (optional_shield, optional_creature_shield) {
            (Some(shield), Some(c_shield)) => Some(shield.into_personal_canonical(&c_shield)),
            (_, _) => None,
        },
        combat_weapon_stats: combat_weapons,
        full_weapons: full_weapons,
        skills: character_skills,
        languages: languages
            .iter()
            .map(|x| x.clone().into_canonical())
            .collect(),
        ability_score_info: ability_score_model,
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
        items: items.iter().map(|x| x.into_canonical()).collect(),
    };
}

fn get_character_skills(
    skills: Vec<structs::Skill>,
    skill_choices: Vec<structs::CharacterSkillChoice>,
    sub_skills: Vec<structs::AugmentedCharacterSubSkillChoice>,
    class_skills: Vec<structs::ClassSkill>,
    class_sub_skills: Vec<structs::ClassSubSkill>,
    class_skill_constructors: Vec<structs::ClassSkillConstructor>,
    class_bonuses: &structs::ClassBonuses,
    abs: &models::AbilityScoreInfo,
    armor_piece: &structs::ExpandedArmorPieceInstance,
    optional_shield: &Option<structs::Shield>,
    optional_creature_shield: &Option<structs::CreatureShield>,
) -> Vec<models::CharacterSkill> {
    let mut ret_skills = Vec::new();
    let choice_map = skill_choice_map(&skill_choices);
    let class_map = class_skill_map(&class_skills);
    let class_sub_set = class_sub_skill_set(&class_sub_skills);
    let class_constructor_set = class_skill_constructor_set(&class_skill_constructors);
    let shield_penalty = match *optional_shield {
        Some(ref s) => s.skill_penalty,
        None => 0,
    };
    let masterwork_ac_reduction = if armor_piece.is_masterwork { -1 } else { 0 };
    let masterwork_shield_ac_reduction = match *optional_creature_shield {
        Some(ref cs) => if cs.is_masterwork {
            -1
        } else {
            0
        },
        None => 0,
    };
    let armor_penalty_value = armor_piece.armor_check_penalty + shield_penalty
        - (class_bonuses.ac_penalty_reduction + masterwork_ac_reduction
            + masterwork_shield_ac_reduction);
    for skill in skills.iter() {
        let armor_penalty = if is_armor_penalized(skill.ability.clone()) {
            Some(armor_penalty_value)
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
            Some(armor_penalty_value)
        } else {
            None
        };
        let count = sub_skill.count;
        let is_class_skill = class_sub_set.contains(&sub_skill.sub_skill_id)
            || class_constructor_set.contains(&sub_skill.skill_constructor_id);
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

fn skill_choice_map<'a>(
    s: &'a Vec<structs::CharacterSkillChoice>,
) -> HashMap<i32, &'a structs::CharacterSkillChoice> {
    let mut m = HashMap::new();
    for s in s.iter() {
        m.insert(s.skill_id, s);
    }
    return m;
}

impl structs::ExpandedCreatureLanguage {
    pub fn into_canonical(&self) -> models::Language {
        models::Language {
            name: self.name.clone(),
        }
    }
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

impl structs::ExpandedArmorPieceInstance {
    pub fn into_canonical(&self) -> models::ArmorPieceInstance {
        models::ArmorPieceInstance {
            armor_class: self.armor_class.clone(),
            name: self.name.clone(),
            armor_bonus: self.armor_bonus,
            max_dex_bonus: self.max_dex_bonus,
            armor_check_penalty: self.armor_check_penalty,
            arcane_spell_failure_chance: self.arcane_spell_failure_chance,
            fast_speed: self.fast_speed,
            slow_speed: self.slow_speed,
            medium_weight: self.medium_weight,
            is_masterwork: self.is_masterwork,
            special: self.special.clone(),
        }
    }
}

impl structs::Shield {
    pub fn into_personal_canonical(
        &self,
        c_shield: &structs::CreatureShield,
    ) -> models::PersonalShield {
        models::PersonalShield {
            shield: models::Shield {
                name: self.name.clone(),
                ac_bonus: self.ac_bonus,
                max_dex: self.max_dex,
                skill_penalty: self.skill_penalty,
                arcane_spell_failure_chance: self.arcane_spell_failure_chance,
                weight: self.weight,
                size_style: self.size_style,
            },
            has_spikes: c_shield.has_spikes,
            is_masterwork: c_shield.is_masterwork,
            special: c_shield.special.clone(),
        }
    }

    pub fn into_canonical(&self) -> models::Shield {
        models::Shield {
            name: self.name.clone(),
            ac_bonus: self.ac_bonus,
            max_dex: self.max_dex,
            skill_penalty: self.skill_penalty,
            arcane_spell_failure_chance: self.arcane_spell_failure_chance,
            weight: self.weight,
            size_style: self.size_style,
        }
    }
}

impl structs::ShieldDamage {
    pub fn into_canonical_weapon(&self) -> models::WeaponInstance {
        let mut name = self.shield_name.clone();
        if self.spiked {
            name = name + " (spiked)";
        }
        models::WeaponInstance {
            weapon: models::Weapon {
                name: name,
                training_type: models::WeaponTrainingType::Martial,
                size_style: self.size_style,
                cost: 1, /* models::CombatWeaponStat doesn't need the cost, which is why we are converting to models::Weapon */
                small_damage: self.small_damage,
                medium_damage: self.medium_damage,
                critical: self.critical,
                range: self.range.unwrap_or(5),
                weight: self.weight,
                damage_type: self.damage_type.clone(),
            },
            is_masterwork: false,
            special: None,
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
            range: self.range.unwrap_or(5),
            weight: self.weight,
            damage_type: self.damage_type.clone(),
        }
    }
}

impl structs::ExpandedWeaponInstance {
    pub fn into_canonical(&self) -> models::WeaponInstance {
        let name = match &self.weapon_instance_name {
            &Some(ref n) => n.clone(),
            &None => self.name.clone(),
        };
        models::WeaponInstance {
            weapon: models::Weapon {
                name: name,
                training_type: self.training_type.clone(),
                size_style: self.size_style.clone(),
                cost: self.cost,
                small_damage: self.small_damage.clone(),
                medium_damage: self.medium_damage.clone(),
                critical: self.critical.clone(),
                range: self.range.unwrap_or(5),
                weight: self.weight,
                damage_type: self.damage_type.clone(),
            },
            is_masterwork: self.is_masterwork,
            special: self.special.clone(),
        }
    }
}

impl structs::ExpandedCreatureItem {
    pub fn into_canonical(&self) -> models::CreatureItem {
        models::CreatureItem {
            id: self.id,
            creature_id: self.creature_id,
            name: self.name.clone(),
            description: self.description.clone(),
            count: self.count,
        }
    }
}

fn build_combat_weapon_stats(
    weapons: &Vec<models::WeaponInstance>,
    size: &models::Size,
    base_attack_bonus: i32,
    abs: &models::AbilityScoreInfo,
) -> Vec<models::CombatWeaponStat> {
    weapons
        .iter()
        .map(|weapon_instance| {
            let (ab_ability_mod, damage_ability_mod) =
                if weapon_instance.weapon.size_style == models::WeaponSizeStyle::Ranged {
                    (abs.dex.modifier, 0)
                } else {
                    (abs.str.modifier, abs.str.modifier)
                };
            models::CombatWeaponStat {
                name: weapon_instance.weapon.name.clone(),
                training_type: weapon_instance.weapon.training_type.clone(),
                size_style: weapon_instance.weapon.size_style.clone(),
                dice_damage: if size >= &models::Size::Medium {
                    weapon_instance.weapon.medium_damage.clone()
                } else {
                    weapon_instance.weapon.small_damage.clone()
                },
                critical: weapon_instance.weapon.critical.clone(),
                range: weapon_instance.weapon.range,
                damage_type: weapon_instance.weapon.damage_type.clone(),
                attack_bonus: base_attack_bonus + ab_ability_mod,
                damage: damage_ability_mod,
            }
        })
        .collect()
}

impl structs::ClassBonuses {
    pub fn into_canonical(&self, abs: &models::AbilityScoreInfo) -> models::SavingThrows {
        let class_cha_bonus = if self.cha_bonus { abs.cha.modifier } else { 0 };
        models::SavingThrows {
            fortitude: build_saving_throw(
                self.fortitude,
                abs.con.modifier,
                class_cha_bonus,
                models::AbilityName::Con,
            ),
            reflex: build_saving_throw(
                self.reflex,
                abs.dex.modifier,
                class_cha_bonus,
                models::AbilityName::Dex,
            ),
            will: build_saving_throw(
                self.will,
                abs.wis.modifier,
                class_cha_bonus,
                models::AbilityName::Wis,
            ),
        }
    }
}

fn build_saving_throw(
    class_base: i32,
    ability_mod: i32,
    other: i32,
    ability_name: models::AbilityName,
) -> models::SavingThrow {
    let total = class_base + ability_mod + other;
    return models::SavingThrow {
        total: total,
        base: class_base,
        ability_mod: ability_mod,
        ability_name: ability_name,
        other: other,
    };
}

fn build_combat_maneuvers(
    abilities: &models::AbilityScoreInfo,
    base_attack_bonus: i32,
    size_mod: i32,
) -> models::CombatManeuvers {
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

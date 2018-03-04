#[derive(Serialize, Deserialize)]
pub struct Character {
    pub id: i32,
    pub level: i32,
    pub ability_scores: AbilityScoreSet,
    pub ability_score_info: AbilityScoreInfo,
    pub meta_information: MetaInformation,
    pub combat_numbers: CombatNumbers,
    pub armor_piece: ArmorPieceInstance,
    pub shield: Option<PersonalShield>,
    pub full_weapons: Vec<WeaponInstance>,
    pub combat_weapon_stats: Vec<CombatWeaponStat>,
    pub skills: Vec<CharacterSkill>,
    pub languages: Vec<Language>,
    pub items: Vec<CreatureItem>,
}

// Combers or Barbers or Numbats
#[derive(Serialize, Deserialize)]
pub struct CombatNumbers {
    pub max_hit_points: i32,
    pub current_hit_points: i32,
    pub nonlethal_damage: i32,
    pub armor_class: ArmorClass,
    pub base_attack_bonus: i32,
    pub saving_throws: SavingThrows,
    pub combat_maneuvers: CombatManeuvers,
}

#[derive(Serialize, Deserialize)]
pub struct CombatManeuvers {
    pub bonus: CombatManeuverBonus,
    pub defense: CombatManeuverDefense,
}

#[derive(Serialize, Deserialize)]
pub struct CombatManeuverBonus {
    pub total: i32,
    pub str: i32,
    pub base_attack_bonus: i32,
    pub size_mod: i32,
}

#[derive(Serialize, Deserialize)]
pub struct CombatManeuverDefense {
    pub total: i32,
    pub base: i32,
    pub str: i32,
    pub dex: i32,
    pub base_attack_bonus: i32,
    pub size_mod: i32,
}

#[derive(Serialize, Deserialize)]
pub struct SavingThrows {
    pub fortitude: SavingThrow,
    pub reflex: SavingThrow,
    pub will: SavingThrow,
}

#[derive(Serialize, Deserialize)]
pub struct SavingThrow {
    pub total: i32,
    pub base: i32,
    pub ability_mod: i32,
    pub other: i32,
    pub ability_name: AbilityName,
}

#[derive(Serialize, Deserialize)]
pub struct ArmorClass {
    pub total: i32,
    pub base: i32,
    pub dex: i32,
    // TODO implement this
    pub deflection_mod: i32,
    // TODO implement this
    pub dodge_mod: i32,
    pub armor_ac: i32,
    pub shield_ac: i32,
    // TODO implement this
    pub natural_armor: i32,
    pub size_mod: i32,
}

#[derive(Serialize, Deserialize)]
pub struct Alignment {
    pub morality: AlignmentMorality,
    pub order: AlignmentOrder,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum AlignmentOrder {
    Chaotic,
    Neutral,
    Lawful,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum AlignmentMorality {
    Evil,
    Neutral,
    Good,
}

#[derive(Serialize, Deserialize, Eq, PartialEq, Ord, PartialOrd)]
#[serde(rename_all = "lowercase")]
pub enum Size {
    Colossal,
    Gargantuan,
    Huge,
    Large,
    Medium,
    Small,
    Tiny,
    Diminutive,
    Fine,
}

impl Size {
    pub fn get_modifier(&self) -> i32 {
        match *self {
            Size::Colossal => -8,
            Size::Gargantuan => -4,
            Size::Huge => -2,
            Size::Large => -1,
            Size::Medium => 0,
            Size::Small => 1,
            Size::Tiny => 2,
            Size::Diminutive => 4,
            Size::Fine => 8,
        }
    }
}


#[derive(Serialize, Deserialize)]
pub struct AbilityScoreSet {
    pub str: i32,
    pub dex: i32,
    pub con: i32,
    pub int: i32,
    pub wis: i32,
    pub cha: i32,
}

#[derive(Serialize, Deserialize)]
pub struct AbilityScoreInfo {
    pub str: ScoreAndMofidier,
    pub dex: ScoreAndMofidier,
    pub con: ScoreAndMofidier,
    pub int: ScoreAndMofidier,
    pub wis: ScoreAndMofidier,
    pub cha: ScoreAndMofidier,
}


impl AbilityScoreInfo {
    pub fn get_ability_mod(&self, ability_name: AbilityName) -> i32 {
        match ability_name {
            AbilityName::Str => self.str.modifier,
            AbilityName::Dex => self.dex.modifier,
            AbilityName::Con => self.con.modifier,
            AbilityName::Int => self.int.modifier,
            AbilityName::Wis => self.wis.modifier,
            AbilityName::Cha => self.cha.modifier,
        }
    }
}

#[derive(Serialize, Deserialize)]
pub struct ScoreAndMofidier {
    pub score: i32,
    pub modifier: i32,
}

#[derive(Serialize, Deserialize)]
pub struct MetaInformation {
    pub name: String,
    pub player_name: String,
    pub alignment: Alignment,
    pub class: String,
    pub race: String,
    pub deity: Option<String>,
    pub age: i32,
    pub size: Size,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum ConcreteSkill {
    Skill(Skill),
    ConstructedSkill(ConstructedSkill),
}

#[derive(Serialize, Deserialize)]
pub struct Skill {
    pub name: String,
    pub ability: AbilityName,
}

#[derive(Serialize, Deserialize)]
pub struct ConstructedSkill {
    pub name: String,
    pub sub_skill: String,
    pub ability: AbilityName,
}

#[derive(Serialize, Deserialize)]
pub struct Language {
    pub name: String,
}

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "lowercase")]
pub enum AbilityName {
    Str,
    Dex,
    Con,
    Int,
    Wis,
    Cha,
}

#[derive(Serialize, Deserialize)]
pub struct CharacterSkill {
    pub name: String,
    pub sub_name: Option<String>,
    pub total: i32,
    pub ability: AbilityName,
    pub ability_mod: i32,
    pub is_class_skill: bool,
    pub class_mod: i32,
    pub count: i32,
    pub armor_check_penalty: Option<i32>,
}

#[derive(Serialize, Deserialize)]
pub struct ArmorPieceInstance {
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

#[derive(Serialize, Deserialize)]
pub struct ArmorPiece {
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

#[derive(Serialize, Deserialize)]
pub struct PersonalShield {
    pub shield: Shield,
    pub has_spikes: bool,
    pub is_masterwork: bool,
    pub special: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct Shield {
    pub name: String,
    pub ac_bonus: i32,
    pub max_dex: Option<i32>,
    pub skill_penalty: i32,
    pub arcane_spell_failure_chance: i32,
    pub weight: i32,
    pub size_style: Option<WeaponSizeStyle>,
}

#[derive(Serialize, Deserialize)]
pub struct CombatWeaponStat {
    pub name: String,
    pub training_type: WeaponTrainingType,
    pub size_style: WeaponSizeStyle,
    pub dice_damage: DiceDamage,
    pub critical: CriticalDamage,
    pub range: i32,
    pub damage_type: PhysicalDamageType,
    pub attack_bonus: i32,
    pub damage: i32,
}

#[derive(Serialize, Deserialize)]
pub struct Weapon {
    pub name: String,
    pub training_type: WeaponTrainingType,
    pub size_style: WeaponSizeStyle,
    pub cost: i32,
    pub small_damage: DiceDamage,
    pub medium_damage: DiceDamage,
    pub critical: CriticalDamage,
    pub range: i32,
    pub weight: i32,
    pub damage_type: PhysicalDamageType,
}

#[derive(Serialize, Deserialize)]
pub struct WeaponInstance {
    pub weapon: Weapon,
    pub is_masterwork: bool,
    pub special: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct CreatureItem {
    pub id: i32,
    pub creature_id: i32,
    pub name: String,
    pub description: String,
    pub count: i32,
}

#[derive(Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum WeaponTrainingType {
    Simple,
    Martial,
    Exotic,
}

#[derive(Clone, Copy, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum WeaponSizeStyle {
    UnarmedMelee,
    LightMelee,
    OneHandedMelee,
    TwoHandedMelee,
    Ranged,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, FromSql, ToSql)]
#[postgres(name = "dice_damage")]
pub struct DiceDamage {
    pub num_dice: i32,
    pub die_size: i32,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, FromSql, ToSql)]
#[postgres(name = "critical_damage")]
pub struct CriticalDamage {
    pub required_roll: i32,
    pub multiplier: i32,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, FromSql, ToSql)]
#[postgres(name = "physical_damage_type")]
pub struct PhysicalDamageType {
    pub bludgeoning: bool,
    pub piercing: bool,
    pub slashing: bool,
    pub and_together: bool,
}

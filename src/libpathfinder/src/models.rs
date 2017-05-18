#[derive(Serialize, Deserialize)]
pub struct Character {
    pub id: i32,
    pub name: String,
    pub ability_scores: AbilityScoreSet,
    pub ability_score_info: AbilityScoreInfo,
    pub alignment: Alignment,
    pub player_name: String,
    pub meta_information: MetaInformation,
    pub combat_numbers: CombatNumbers,
    pub armor_piece: ArmorPiece,
    pub skills: Vec<CharacterSkill>,
}

// Combers or Barbers or Numbats
#[derive(Serialize, Deserialize)]
pub struct CombatNumbers {
    pub max_hit_points: i32,
    pub current_hit_points: i32,
    pub nonlethal_damage: i32,
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

#[derive(Serialize, Deserialize)]
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

#[derive(Serialize, Deserialize)]
pub struct ScoreAndMofidier {
    pub score: i32,
    pub modifier: i32,
}

#[derive(Serialize, Deserialize)]
pub struct MetaInformation {
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

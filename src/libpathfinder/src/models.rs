#[derive(Serialize, Deserialize)]
pub struct Character {
    pub id: i32,
    pub name: String,
    pub ability_scores: AbilityScoreSet,
    pub alignment: Alignment,
    pub player_name: String,
    pub meta_information: MetaInformation,
    pub combat_numbers: CombatNumbers,
}

// Combers or Barbers or Numbats
#[derive(Serialize, Deserialize)]
pub struct CombatNumbers {
    pub max_hit_points: i32,
    pub current_hit_points: i32,
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
pub struct MetaInformation {
    pub class: String,
    pub race: String,
    pub deity: Option<String>,
    pub age: i32,
    pub size: Size,
}

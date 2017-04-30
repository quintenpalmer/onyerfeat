#[derive(Serialize, Deserialize)]
pub struct Character {
    pub id: u32,
    pub name: String,
    pub ability_scores: AbilityScoreSet,
}

#[derive(Serialize, Deserialize)]
pub struct AbilityScoreSet {
    pub str: u32,
    pub dex: u32,
    pub con: u32,
    pub int: u32,
    pub wis: u32,
    pub cha: u32,
}

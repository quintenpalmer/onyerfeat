#[derive(Serialize, Deserialize)]
pub struct Character {
    name: String,
}

impl Character {
    pub fn new(name: String) -> Character {
        return Character { name: name };
    }
}

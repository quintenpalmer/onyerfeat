#[derive(Serialize, Deserialize)]
pub struct Character {
    id: u32,
    name: String,
}

impl Character {
    pub fn new(id: u32, name: String) -> Character {
        return Character {
            id: id,
            name: name,
        };
    }
}

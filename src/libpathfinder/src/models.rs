use serde_json;

#[derive(Serialize, Deserialize)]
pub struct Character {
    name: String,
}

impl Character {
    pub fn new(name: String) -> Character {
        return Character { name: name };
    }
}

#[derive(Debug)]
pub enum Error {
    Json(serde_json::Error),
}

use rusqlite;
use libpathfinder_common::error;

#[derive(Serialize, Deserialize, FromDB)]
#[from_db(table_name = "characters")]
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

use rusqlite;
use libpathfinder_common::error;

#[derive(Serialize, Deserialize, FromDB)]
#[from_db(table_name = "characters")]
pub struct Character {
    pub id: u32,
    pub name: String,
}

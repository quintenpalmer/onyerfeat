#[macro_use]
extern crate iron;
extern crate serde;
extern crate serde_json;
#[macro_use]
extern crate serde_derive;
extern crate rusqlite;

pub mod error;
pub mod webshared;

pub trait QueryParam {
    fn parse_from(&mut iron::Request) -> iron::IronResult<Self> where Self: Sized;
}

pub trait FromDB {
    fn select_one(conn: &rusqlite::Connection, id: i32) -> Result<Self, error::Error>
        where Self: Sized;
}

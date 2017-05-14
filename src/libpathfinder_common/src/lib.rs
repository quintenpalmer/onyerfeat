#[macro_use]
extern crate iron;
extern crate serde;
extern crate serde_json;
#[macro_use]
extern crate serde_derive;
extern crate postgres;

pub mod error;
pub mod webshared;

pub trait QueryParam {
    fn parse_from(&mut iron::Request) -> iron::IronResult<Self> where Self: Sized;
}

pub trait FromDB {
    fn select_one(conn: &postgres::GenericConnection, id: i32) -> Result<Self, error::Error>
        where Self: Sized;
}

pub trait TableNamer {
    fn get_table_name() -> String;
}

pub trait FromRow {
    fn parse_row(row: postgres::rows::Row) -> Result<Self, error::Error> where Self: Sized;
}

#[macro_use]
extern crate iron;
extern crate postgres;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

pub mod error;
pub mod webshared;

pub trait QueryParam {
    fn parse_from(&mut iron::Request) -> iron::IronResult<Self>
    where
        Self: Sized;
}

pub trait TableNamer {
    fn get_table_name() -> String;
}

pub trait FromRow {
    fn parse_row(row: postgres::rows::Row) -> Result<Self, error::Error>
    where
        Self: Sized;
}

pub trait Datastore {
    fn prepare<'a>(&'a self, query: &str) -> postgres::Result<postgres::stmt::Statement<'a>>;
}

impl Datastore for postgres::Connection {
    fn prepare<'a>(&'a self, query: &str) -> postgres::Result<postgres::stmt::Statement<'a>> {
        return self.prepare(query);
    }
}

impl<'b> Datastore for postgres::transaction::Transaction<'b> {
    fn prepare<'a>(&'a self, query: &str) -> postgres::Result<postgres::stmt::Statement<'a>> {
        return self.prepare(query);
    }
}

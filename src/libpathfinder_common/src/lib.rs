extern crate iron;
extern crate serde_json;
extern crate rusqlite;

pub mod error;

pub trait QueryParam {
    fn parse_from(&mut iron::Request) -> iron::IronResult<Self> where Self: Sized;
}

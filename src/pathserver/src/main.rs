extern crate libpathfinder as libpf;
extern crate rustc_serialize;
#[macro_use]
extern crate iron;
extern crate urlencoded;

mod webshared;
mod error;
mod char_handler;
use error::Error;

fn main() {
    match run_app() {
        Ok(()) => println!("ran successfully"),
        Err(err) => println!("error during execution: {:?}", err),
    }
}

fn run_app() -> Result<(), Error> {
    println!("serving pathfinder characters");
    try!(iron::Iron::new(char_handler::character_handler)
        .http("localhost:3000")
        .map_err(Error::IronHttpError));
    println!("finished serving; exiting");
    return Ok(());
}

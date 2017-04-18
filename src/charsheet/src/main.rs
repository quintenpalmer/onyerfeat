extern crate libpathfinder as libpf;
extern crate rustc_serialize;

use rustc_serialize::json;

use libpf::models;

fn main() {
    match run_app() {
        Ok(()) => println!("ran successfully"),
        Err(err) => println!("error during execution: {:?}", err),
    }
}

fn run_app() -> Result<(), models::Error> {
    let c = models::Character::new("Idrigoth".to_string());
    println!("character: {}",
             try!(json::encode(&c).map_err(models::Error::Json)));
    return Ok(());
}

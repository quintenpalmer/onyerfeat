extern crate libpathfinder as libpf;
extern crate serde_json;

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
             try!(serde_json::to_string(&c).map_err(models::Error::Json)));
    return Ok(());
}

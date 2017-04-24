extern crate libpathfinder as libpf;
extern crate iron;

fn main() {
    match run_app() {
        Ok(()) => println!("ran successfully"),
        Err(err) => println!("error during execution: {:?}", err),
    }
}


#[derive(Debug)]
struct IronHttpError {
    err: iron::error::HttpError,
}

impl IronHttpError {
    fn new(err: iron::error::HttpError) -> IronHttpError {
        IronHttpError { err: err }
    }
}

fn run_app() -> Result<(), IronHttpError> {
    println!("serving pathfinder characters");
    let handler = libpf::web::Handler {};
    try!(iron::Iron::new(handler)
        .http("localhost:3000")
        .map_err(IronHttpError::new));
    println!("finished serving; exiting");
    return Ok(());
}

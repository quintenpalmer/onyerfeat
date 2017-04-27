use iron;
use iron::IronResult;
use iron::Plugin;

use datastore;
use libpathfinder_common::webshared;
use libpathfinder_common::error::Error;

use libpathfinder_common::QueryParam;

pub struct Handler {
    path: String,
}

impl Handler {
    pub fn new(path: String) -> Handler {
        return Handler { path: path };
    }
}


impl iron::middleware::Handler for Handler {
    fn handle(&self, req: &mut iron::Request) -> IronResult<iron::Response> {
        let full_path = req.url.path().join("/");
        println!("full path is: {}", full_path);
        let conn = itry!(datastore::Datastore::new(&self.path),
                         webshared::simple_server_error());
        match full_path.clone().as_ref() {
            "character" => character_handler(conn, req),
            _ => path_not_found(full_path),
        }
    }
}

#[derive(QueryParam)]
struct IdParam {
    pub id: u32,
}

fn character_handler(ds: datastore::Datastore,
                     req: &mut iron::Request)
                     -> IronResult<iron::Response> {
    println!("handling request for character");

    let id_param = try!(IdParam::parse_from(req));

    let c = itry!(ds.get_character(id_param.id),
                  webshared::simple_server_error());

    let resp = try!(webshared::Response { data: c }.encode());

    return Ok(resp);
}

fn path_not_found(full_path: String) -> IronResult<iron::Response> {
    let (status, msg) = webshared::not_found("path does not exist".to_owned());

    Err(iron::IronError::new(Error::PathNotFound(full_path), (status, msg)))
}

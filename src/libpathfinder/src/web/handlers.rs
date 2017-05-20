use rand;
use rand::distributions::IndependentSample;

use iron;
use iron::IronResult;

use datastore;
use libpathfinder_common::webshared;
use libpathfinder_common::error::Error;

use libpathfinder_common::QueryParam;

pub struct Handler {
    connection_params: String,
}

impl Handler {
    pub fn new(connection_params: String) -> Handler {
        return Handler { connection_params: connection_params };
    }
}


impl iron::middleware::Handler for Handler {
    fn handle(&self, req: &mut iron::Request) -> IronResult<iron::Response> {
        let full_path = req.url.path().join("/");
        println!("full path is: {}", full_path);
        let conn = itry!(datastore::Datastore::new(self.connection_params.clone()),
                         webshared::simple_server_error());
        let resp = match full_path.clone().as_ref() {
            "api/characters" => character_handler(conn, req),
            "api/skills" => skills_handler(conn),
            "api/armor_pieces" => armor_pieces_handler(conn),
            "api/shields" => shields_handler(conn),
            "api/roll" => dice_roll_handler(req),
            _ => path_not_found(full_path),
        };
        match resp {
            Ok(s) => Ok(s),
            Err(e) => {
                println!("{}", e);
                Err(e)
            }
        }
    }
}

#[derive(QueryParam)]
struct IdParam {
    pub id: i32,
}

fn character_handler(ds: datastore::Datastore,
                     req: &mut iron::Request)
                     -> IronResult<iron::Response> {
    println!("handling request for character");

    let id_param = try!(IdParam::parse_from(req));

    let c = itry!(ds.get_character(id_param.id),
                  webshared::simple_server_error());

    return webshared::Response { data: c }.encode();
}

fn skills_handler(ds: datastore::Datastore) -> IronResult<iron::Response> {
    println!("handling request for character");

    let c = itry!(ds.get_skills(), webshared::simple_server_error());

    return webshared::Response { data: c }.encode();
}

fn armor_pieces_handler(ds: datastore::Datastore) -> IronResult<iron::Response> {
    println!("handling request for armor pieces");
    let a = itry!(ds.get_armor_pieces(), webshared::simple_server_error());

    return webshared::Response { data: a }.encode();
}

fn shields_handler(ds: datastore::Datastore) -> IronResult<iron::Response> {
    println!("handling request for shields");
    let a = itry!(ds.get_shields(), webshared::simple_server_error());

    return webshared::Response { data: a }.encode();
}


#[derive(QueryParam)]
struct DiceParam {
    pub die: i32,
}

fn dice_roll_handler(req: &mut iron::Request) -> IronResult<iron::Response> {
    println!("handling request for dice roll");

    let dice_param = try!(DiceParam::parse_from(req));

    let between = rand::distributions::Range::new(1, dice_param.die + 1);
    let mut rng = rand::thread_rng();
    let roll = between.ind_sample(&mut rng);

    return webshared::Response { data: roll }.encode();
}

fn path_not_found(full_path: String) -> IronResult<iron::Response> {
    let (status, msg) = webshared::not_found("path does not exist".to_owned());

    Err(iron::IronError::new(Error::PathNotFound(full_path), (status, msg)))
}

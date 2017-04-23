use iron;
use iron::IronResult;
use iron::Plugin;

use urlencoded::UrlEncodedQuery;

use models;

use web::webshared;
use error::Error;

pub struct Handler {
}

impl Handler {
    pub fn new() -> Handler {
        return Handler {};
    }
}


impl iron::middleware::Handler for Handler {
    fn handle(&self, req: &mut iron::Request) -> IronResult<iron::Response> {
        let full_path = req.url.path().join("/");
        println!("full path is: {}", full_path);
        match full_path.clone().as_ref() {
            "" => index_handler(req),
            _ => path_not_found(full_path),
        }
    }
}

fn index_handler(req: &mut iron::Request) -> IronResult<iron::Response> {
    println!("handling request for character");

    let name = try!(parse_query_param_name(req));

    let c = models::Character::new(1, name);

    let resp = try!(webshared::Response { data: c }.encode());

    return Ok(resp);
}

fn parse_query_param_name(req: &mut iron::Request) -> IronResult<String> {
    let query_params = itry!(req.get_ref::<UrlEncodedQuery>(),
                             webshared::bad_request("must supply 'name' query parameter"
                                 .to_owned()));
    let key = "name".to_owned();
    let names = itry!(query_params.get(&key)
                          .ok_or(Error::MissingQueryParam(key.clone())),
                      webshared::bad_request("must supply 'name' query parameter".to_owned()));

    let name = itry!(if names.len() == 1 {
                         Ok(names.get(0).unwrap().to_uppercase())
                     } else {
                         Err(Error::TooManyQueryParams(key))
                     },
                     webshared::bad_request("must supply only one 'name' query parameter"
                         .to_owned()));
    return Ok(name.to_owned());
}

fn path_not_found(full_path: String) -> IronResult<iron::Response> {
    let (status, msg) = webshared::not_found("path does not exist".to_owned());

    Err(iron::IronError::new(Error::PathNotFound(full_path), (status, msg)))
}

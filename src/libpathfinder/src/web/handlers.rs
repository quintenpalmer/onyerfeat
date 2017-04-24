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
            "character" => character_handler(req),
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

fn character_handler(req: &mut iron::Request) -> IronResult<iron::Response> {
    println!("handling request for character");

    let id = try!(parse_query_param_id(req));

    let c = models::Character::new(id, "replaceme".to_owned());

    let resp = try!(webshared::Response { data: c }.encode());

    return Ok(resp);
}

fn parse_query_param_id(req: &mut iron::Request) -> IronResult<u32> {
    let query_params = itry!(req.get_ref::<UrlEncodedQuery>(),
                             webshared::bad_request("must supply 'id' query parameter".to_owned()));
    let key = "id".to_owned();
    let names = itry!(query_params.get(&key)
                          .ok_or(Error::MissingQueryParam(key.clone())),
                      webshared::bad_request("must supply 'id' query parameter".to_owned()));

    let id;
    if names.len() == 1 {
        let s = names.get(0).unwrap();
        id = itry!(s.parse::<u32>().map_err(Error::ParseInt),
                   webshared::bad_request("query parameter: 'id' must be an int".to_owned()));
    } else {
        return Err(iron::IronError::new(Error::TooManyQueryParams(key),
                                        webshared::bad_request("must supply only one 'id' \
                                                                query parameter"
                                            .to_owned())));

    }
    return Ok(id.to_owned());
}

fn path_not_found(full_path: String) -> IronResult<iron::Response> {
    let (status, msg) = webshared::not_found("path does not exist".to_owned());

    Err(iron::IronError::new(Error::PathNotFound(full_path), (status, msg)))
}

use iron;
use iron::IronResult;
use iron::Plugin;

use urlencoded::UrlEncodedQuery;

use libpf::models;

use webshared;
use error::Error;

pub fn character_handler(req: &mut iron::Request) -> IronResult<iron::Response> {
    println!("handling request for character");

    let name = try!(parse_query_param(req));

    let c = models::Character::new(name);

    let resp = try!(webshared::Response { data: c }.encode());

    return Ok(resp);
}

fn parse_query_param(req: &mut iron::Request) -> IronResult<String> {
    let query_params = itry!(req.get_ref::<UrlEncodedQuery>(),
                             webshared::bad_request("must supply 'name' query parameter"
                                 .to_owned()));
    let key = "name".to_owned();
    let names = itry!(query_params.get(&key)
                          .ok_or(Error::MissingQueryParam(key.clone())),
                      webshared::bad_request("must supply 'name' query parameter".to_owned()));

    let name = itry!(if names.len() == 1 {
                         Ok(names.get(0).unwrap())
                     } else {
                         Err(Error::TooManyQueryParams(key))
                     },
                     webshared::bad_request("must supply only one 'name' query parameter"
                         .to_owned()));
    return Ok(name.to_owned());
}

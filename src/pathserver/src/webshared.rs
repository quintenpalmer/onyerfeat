use rustc_serialize;
use rustc_serialize::json;

use iron;
use iron::status;

#[derive(RustcDecodable, RustcEncodable)]
pub struct Response<T: rustc_serialize::Encodable> {
    pub data: T,
}

impl<T: rustc_serialize::Encodable> Response<T> {
    pub fn encode(&self) -> iron::IronResult<iron::Response> {
        let msg = itry!(json::encode(self),
                        server_error("could not encode json response".to_owned()));

        println!("responding with: {}", msg);
        let mut resp = iron::Response::with((status::Ok, msg));
        resp.headers.set(iron::headers::AccessControlAllowOrigin::Any);
        return Ok(resp);
    }
}

#[derive(RustcDecodable, RustcEncodable)]
pub struct ErrMessage<T: rustc_serialize::Encodable> {
    pub error: T,
}

pub fn server_error(msg: String) -> (status::Status, String) {
    return status_message(status::InternalServerError, msg);
}

pub fn bad_request(msg: String) -> (status::Status, String) {
    return status_message(status::BadRequest, msg);
}

fn status_message(s: status::Status, msg: String) -> (status::Status, String) {
    let json_msg = json::encode(&ErrMessage { error: msg }).unwrap();
    return (s, json_msg);
}

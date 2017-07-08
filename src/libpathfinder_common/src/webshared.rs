use serde;
use serde_json;

use iron;
use iron::status;

#[derive(Serialize, Deserialize)]
pub struct Response<T: serde::Serialize> {
    pub data: T,
}

impl<T: serde::Serialize> Response<T> {
    pub fn encode(&self) -> iron::IronResult<iron::Response> {
        let msg = itry!(serde_json::to_string(self),
                        server_error("could not encode json response".to_owned()));

        println!("responding with: {}", msg);
        let mut resp = iron::Response::with((status::Ok, msg));
        resp.headers.set(iron::headers::AccessControlAllowOrigin::Any);
        return Ok(resp);
    }
}

#[derive(Serialize, Deserialize)]
pub struct ErrMessage<T: serde::Serialize> {
    pub error: T,
}

pub fn simple_server_error() -> (status::Status, String) {
    return status_message(status::InternalServerError,
                          "internal_server_error".to_owned());
}

pub fn server_error(msg: String) -> (status::Status, String) {
    return status_message(status::InternalServerError, msg);
}

pub fn bad_request(msg: String) -> (status::Status, String) {
    return status_message(status::BadRequest, msg);
}

pub fn not_found(msg: String) -> (status::Status, String) {
    return status_message(status::NotFound, msg);
}

pub fn method_not_allowed(msg: String) -> (status::Status, String) {
    return status_message(status::MethodNotAllowed, msg);
}

fn status_message(s: status::Status, msg: String) -> (status::Status, String) {
    let json_msg = serde_json::to_string(&ErrMessage { error: msg }).unwrap();
    return (s, json_msg);
}

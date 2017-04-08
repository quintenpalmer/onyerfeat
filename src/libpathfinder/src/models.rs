use rustc_serialize::json;

#[derive(RustcDecodable, RustcEncodable)]
pub struct Character {
    name: String,
}

impl Character {
    pub fn new(name: String) -> Character {
        return Character { name: name };
    }
}

#[derive(Debug)]
pub enum Error {
    Json(json::EncoderError),
}

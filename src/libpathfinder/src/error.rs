use std::fmt;
use std::num;
use std::error::Error as StdError;

use serde_json;

#[derive(Debug)]
pub enum Error {
    Json(serde_json::Error),
    ParseInt(num::ParseIntError),
    PathNotFound(String),
    MissingQueryParam(String),
    TooManyQueryParams(String),
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        self.description().fmt(f)
    }
}

impl StdError for Error {
    fn description(&self) -> &str {
        match *self {
            Error::Json(ref err) => err.description(),
            Error::ParseInt(ref err) => err.description(),
            Error::PathNotFound(_) => "requested path does not exist",
            Error::MissingQueryParam(_) => "could not find expected query param",
            Error::TooManyQueryParams(_) => "found too many query param values",
        }
    }

    fn cause(&self) -> Option<&StdError> {
        match *self {
            Error::Json(ref err) => Some(err),
            Error::ParseInt(ref err) => Some(err),
            _ => None,
        }
    }
}

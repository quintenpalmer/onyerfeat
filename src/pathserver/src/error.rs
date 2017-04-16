use std::fmt;
use std::error::Error as StdError;

use iron;

#[derive(Debug)]
pub enum Error {
    IronHttpError(iron::error::HttpError),
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
            Error::IronHttpError(ref err) => err.description(),
            Error::MissingQueryParam(_) => "could not find expected query param",
            Error::TooManyQueryParams(_) => "found too many query param values",
        }
    }

    fn cause(&self) -> Option<&StdError> {
        match *self {
            Error::IronHttpError(ref err) => Some(err),
            _ => None,
        }
    }
}

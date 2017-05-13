use std::fmt;
use std::num;
use std::error::Error as StdError;

use postgres;
use serde_json;

#[derive(Debug)]
pub enum Error {
    Json(serde_json::Error),
    Postgres(postgres::error::Error),
    PostgresConnect(postgres::error::ConnectError),
    ParseError,
    ManyResultsOnSelectOne(String),
    ParseInt(num::ParseIntError),
    PathNotFound(String),
    MissingQueryParam(String),
    TooManyQueryParams(String),
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        match *self {
            Error::Postgres(ref e) => e.fmt(f),
            Error::PostgresConnect(ref e) => e.fmt(f),
            Error::ParseInt(ref e) => e.fmt(f),
            _ => self.description().fmt(f),
        }
    }
}

impl StdError for Error {
    fn description(&self) -> &str {
        match *self {
            Error::Json(ref err) => err.description(),
            Error::Postgres(ref err) => err.description(),
            Error::PostgresConnect(ref err) => err.description(),
            Error::ParseError => "could not parse from database",
            Error::ManyResultsOnSelectOne(_) => "many results found on select expecting one result",
            Error::ParseInt(ref err) => err.description(),
            Error::PathNotFound(_) => "requested path does not exist",
            Error::MissingQueryParam(_) => "could not find expected query param",
            Error::TooManyQueryParams(_) => "found too many query param values",
        }
    }

    fn cause(&self) -> Option<&StdError> {
        match *self {
            Error::Json(ref err) => Some(err),
            Error::Postgres(ref err) => Some(err),
            Error::PostgresConnect(ref err) => Some(err),
            Error::ParseInt(ref err) => Some(err),
            _ => None,
        }
    }
}

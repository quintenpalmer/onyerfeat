use postgres;

use libpathfinder_common::FromRow;
use libpathfinder_common::TableNamer;
use libpathfinder_common::error;
use libpathfinder_common::Datastore;

pub fn exec_and_select_optional_one_by_field<T, F>(conn: &Datastore,
                                                   query: &'static str,
                                                   id: F)
                                                   -> Result<Option<T>, error::Error>
    where T: FromRow,
          F: postgres::types::ToSql
{
    let stmt = try!(conn.prepare(query).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    return match rows.len() {
        0 => Ok(None),
        1 => {
            let row = rows.get(0);
            match T::parse_row(row) {
                Ok(o) => Ok(Some(o)),
                Err(e) => Err(e),
            }
        }
        _ => Err(error::Error::ManyResultsOnSelectOne("creature armor query".to_string())),
    };
}

pub fn exec_and_select_one_by_two_fields<T, F, I>(conn: &Datastore,
                                                  query: &'static str,
                                                  id1: F,
                                                  id2: I)
                                                  -> Result<T, error::Error>
    where T: FromRow,
          F: postgres::types::ToSql,
          I: postgres::types::ToSql
{
    let stmt = try!(conn.prepare(query).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id1, &id2]).map_err(error::Error::Postgres));
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne("custom sql query".to_string()));
    }
    let row = rows.get(0);
    return T::parse_row(row);
}

pub fn exec_and_select_one_by_field<T, F>(conn: &Datastore,
                                          query: &'static str,
                                          id: F)
                                          -> Result<T, error::Error>
    where T: FromRow,
          F: postgres::types::ToSql
{
    let stmt = try!(conn.prepare(query).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne("creature armor query".to_string()));
    }
    let row = rows.get(0);
    return T::parse_row(row);
}

pub fn exec_and_select_by_field<T, F>(conn: &Datastore,
                                      query: &'static str,
                                      id: F)
                                      -> Result<Vec<T>, error::Error>
    where T: FromRow,
          F: postgres::types::ToSql
{
    let stmt = try!(conn.prepare(query).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_all<T>(conn: &Datastore) -> Result<Vec<T>, error::Error>
    where T: FromRow + TableNamer
{
    let query = format!("SELECT * FROM {}", T::get_table_name());
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_by_field<T, F>(conn: &Datastore, id_name: &str, id: F) -> Result<Vec<T>, error::Error>
    where T: FromRow + TableNamer,
          F: postgres::types::ToSql
{
    let query = format!("SELECT * FROM {} WHERE {} = $1",
                        T::get_table_name(),
                        id_name);
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    let mut ret = Vec::new();
    for row in rows.iter() {
        ret.push(try!(T::parse_row(row)));
    }
    return Ok(ret);
}

pub fn select_optional_one_by_field<T, F>(conn: &Datastore,
                                          id_name: &str,
                                          id: F)
                                          -> Result<Option<T>, error::Error>
    where T: FromRow + TableNamer,
          F: postgres::types::ToSql
{
    let query = format!("SELECT * FROM {} WHERE {} = $1",
                        T::get_table_name(),
                        id_name);
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    return match rows.len() {
        0 => Ok(None),
        1 => {
            let row = rows.get(0);
            match T::parse_row(row) {
                Ok(o) => Ok(Some(o)),
                Err(e) => Err(e),
            }
        }
        _ => Err(error::Error::ManyResultsOnSelectOne("creature armor query".to_string())),
    };
}

pub fn select_one_by_field<T, F>(conn: &Datastore, id_name: &str, id: F) -> Result<T, error::Error>
    where T: FromRow + TableNamer,
          F: postgres::types::ToSql
{
    let query = format!("SELECT * FROM {} WHERE {} = $1",
                        T::get_table_name(),
                        id_name);
    let stmt = try!(conn.prepare(query.as_str()).map_err(error::Error::Postgres));

    let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
    if rows.len() != 1 {
        return Err(error::Error::ManyResultsOnSelectOne(T::get_table_name().to_string()));
    }
    let row = rows.get(0);
    return T::parse_row(row);
}

pub fn select_one_by_id<T>(conn: &Datastore, id: i32) -> Result<T, error::Error>
    where T: FromRow + TableNamer
{
    select_one_by_field(conn, "id", id)
}

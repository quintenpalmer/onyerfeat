use postgres;

use libpathfinder_common::FromRow;
use libpathfinder_common::TableNamer;
use libpathfinder_common::error;

pub fn exec_and_select_by_field<T, F>(conn: &postgres::Connection,
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

pub fn select_all<T>(conn: &postgres::Connection) -> Result<Vec<T>, error::Error>
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

pub fn select_by_field<T, F>(conn: &postgres::Connection,
                             id_name: &str,
                             id: F)
                             -> Result<Vec<T>, error::Error>
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

pub fn select_one_by_field<T, F>(conn: &postgres::Connection,
                                 id_name: &str,
                                 id: F)
                                 -> Result<T, error::Error>
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

pub fn select_one_by_id<T>(conn: &postgres::Connection, id: i32) -> Result<T, error::Error>
    where T: FromRow + TableNamer
{
    select_one_by_field(conn, "id", id)
}
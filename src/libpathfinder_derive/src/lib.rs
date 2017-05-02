#![recursion_limit = "192"]

extern crate proc_macro;
use proc_macro::TokenStream;

extern crate syn;

#[macro_use]
extern crate quote;

use syn::MetaItem::{List, NameValue};
use syn::NestedMetaItem::MetaItem;

#[proc_macro_derive(QueryParam)]
pub fn query_param_macro(input: TokenStream) -> TokenStream {
    let source = input.to_string();

    // Parse the string representation into a syntax tree
    let ast = syn::parse_derive_input(&source).unwrap();

    // Build the output, possibly using quasi-quotation
    let expanded = derive_query_param(&ast);

    // Parse back to a token stream and return it
    expanded.parse().unwrap()
}

fn derive_query_param(ast: &syn::DeriveInput) -> quote::Tokens {
    let (field_name, ty) = match ast.body {
        syn::Body::Struct(ref data) => {
            if data.fields().len() != 1 {
                panic!("#[derive(QueryParam)] must have only one field");
            }

            let ref field = data.fields()[0];
            (field.ident.as_ref().unwrap(), field.ty.clone())
        }
        syn::Body::Enum(_) => panic!("#[derive(QueryParam)] can only be used with structs"),
    };

    // Used in the quasi-quotation below as `#name`
    let name = &ast.ident;

    // Helper is provided for handling complex generic types correctly and effortlessly
    let (impl_generics, ty_generics, where_clause) = ast.generics.split_for_impl();

    quote! {
        impl #impl_generics ::libpathfinder_common::QueryParam for #name #ty_generics #where_clause {
            fn parse_from(req: &mut iron::Request) -> iron::IronResult<Self> {

                use iron::Plugin;
                use urlencoded::UrlEncodedQuery;
                use libpathfinder_common::error::Error;
                use libpathfinder_common::webshared;

                let query_params = itry!(req.get_ref::<UrlEncodedQuery>(),
                                         webshared::bad_request("must supply 'id' query parameter".to_owned()));
                let key = stringify!(#field_name).to_string();
                let names = itry!(query_params.get(&key)
                                  .ok_or(Error::MissingQueryParam(key.clone())),
                                  webshared::bad_request("must supply 'id' query parameter".to_owned()));

                let val;
                if names.len() == 1 {
                    let s = names.get(0).unwrap();
                    val = itry!(s.parse::<#ty>().map_err(Error::ParseInt),
                                webshared::bad_request("query parameter: 'id' must be an int".to_owned()));
                } else {
                    return Err(iron::IronError::new(Error::TooManyQueryParams(key),
                                                    webshared::bad_request("must supply only one 'id' \
                                                                            query parameter"
                                                    .to_owned())));
                }
                return Ok(#name{
                    #field_name: val,
                });
            }
        }
    }
}

#[proc_macro_derive(FromDB, attributes(from_db))]
pub fn sqlite_table_macro(input: TokenStream) -> TokenStream {
    let source = input.to_string();

    // Parse the string representation into a syntax tree
    let ast = syn::parse_derive_input(&source).unwrap();

    // Build the output, possibly using quasi-quotation
    let expanded = derive_sqlite_table(&ast);

    // Parse back to a token stream and return it
    expanded.parse().unwrap()
}

fn derive_sqlite_table(ast: &syn::DeriveInput) -> quote::Tokens {
    let (field_names, field_assignments) = match ast.body {
        syn::Body::Struct(ref data) => {
            if data.fields().len() == 0 {
                panic!("#[derive(FromDB)] must have at least one field");
            }

            let mut i = 0;
            let mut field_assignments = Vec::new();
            let mut field_names = Vec::new();
            for field_syn in data.fields() {
                let field = field_syn.ident.as_ref().unwrap();
                field_names.push(field.as_ref());
                field_assignments.push(quote! { #field: row.get(#i) });
                i = i + 1;
            }

            (field_names, field_assignments)
        }
        syn::Body::Enum(_) => panic!("#[derive(FromDB)] can only be used with structs"),
    };

    let from_db_usage = "#[from_db(\"table_name\" = \"...\")]";

    let mut o_table_name = None;
    for meta_items in ast.attrs.iter().filter_map(get_db_meta_items) {
        for meta_item in meta_items {
            match meta_item {
                // Parse `#[from_db(table_name = "foo")]`
                MetaItem(NameValue(ref name, ref lit)) if name == "table_name" => {
                    let s = get_string_from_lit(name.as_ref(), name.as_ref(), lit);
                    o_table_name = Some(s);
                }
                _ => {
                    panic!(format!("incorrect usage of custom attribute, use: {}",
                                   from_db_usage))
                }
            }
        }
    }

    let table_name = match o_table_name {
        Some(s) => s,
        None => panic!(format!("must provide the table name: {}", from_db_usage)),
    };

    // Used in the quasi-quotation below as `#name`
    let name = &ast.ident;

    // Helper is provided for handling complex generic types correctly and effortlessly
    let (impl_generics, ty_generics, where_clause) = ast.generics.split_for_impl();

    let field_query = field_names.join(", ");

    let query = format!("SELECT {} FROM {} WHERE id = ?1", field_query, table_name);

    quote! {
        impl #impl_generics ::libpathfinder_common::FromDB for #name #ty_generics #where_clause {
            fn select_one(conn: &rusqlite::Connection, id: i32) -> Result<Self, error::Error> {
                let mut stmt = conn.prepare(#query).unwrap();
                let s =
                    try!(stmt.query_row(&[&id], |row| {
                        #name { #(#field_assignments),* }
                    }).map_err(error::Error::Rusqlite));

                return Ok(s);
            }
        }
    }
}

fn get_db_meta_items(attr: &syn::Attribute) -> Option<Vec<syn::NestedMetaItem>> {
    match attr.value {
        List(ref name, ref items) if name == "from_db" => Some(items.iter().cloned().collect()),
        _ => None,
    }
}

fn get_string_from_lit(attr_name: &str, meta_item_name: &str, lit: &syn::Lit) -> String {
    if let syn::Lit::Str(ref s, _) = *lit {
        s.clone()
    } else {
        panic!(format!("expected from_db {} attribute to be a string: `{} = \"...\"`",
                       attr_name,
                       meta_item_name));
    }
}

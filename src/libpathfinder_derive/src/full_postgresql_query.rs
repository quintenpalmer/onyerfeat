use quote;
use syn;

use syn::MetaItem::{List, NameValue};
use syn::NestedMetaItem::MetaItem;

pub fn derive_sqlite_table(ast: &syn::DeriveInput) -> quote::Tokens {
    let (field_names, field_assignments) = match ast.body {
        syn::Body::Struct(ref data) => {
            if data.fields().len() == 0 {
                panic!("#[derive(FromDB)] must have at least one field");
            }

            let mut i: usize = 0;
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

    let query = format!("SELECT {} FROM {} WHERE id = $1", field_query, table_name);

    quote! {
        impl #impl_generics ::libpathfinder_common::FromDB for #name #ty_generics #where_clause {
            fn select_one(conn: &postgres::GenericConnection, id: i32) -> Result<Self, error::Error> {
                let stmt = conn.prepare(#query).unwrap();

                let rows = try!(stmt.query(&[&id]).map_err(error::Error::Postgres));
                if rows.len() != 1 {
                    return Err(error::Error::ManyResultsOnSelectOne(#table_name.to_string()))
                }
                let row = rows.get(0);
                return Ok(#name { #(#field_assignments),* });
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

use quote;
use syn;

use syn::MetaItem::{List, NameValue};
use syn::NestedMetaItem::MetaItem;

pub fn derive_table_namer(ast: &syn::DeriveInput) -> quote::Tokens {
    let table_namer_usage = "#[table_namer(\"table_name\" = \"...\")]";

    let mut o_table_name = None;
    for meta_items in ast.attrs.iter().filter_map(get_table_meta_items) {
        for meta_item in meta_items {
            match meta_item {
                // Parse `#[table_namer(table_name = "foo")]`
                MetaItem(NameValue(ref name, ref lit)) if name == "table_name" => {
                    let s = get_string_from_lit(name.as_ref(), name.as_ref(), lit);
                    o_table_name = Some(s);
                }
                _ => panic!(format!(
                    "incorrect usage of custom attribute, use: {}",
                    table_namer_usage
                )),
            }
        }
    }

    let table_name = match o_table_name {
        Some(s) => s,
        None => panic!(format!(
            "must provide the table name: {}",
            table_namer_usage
        )),
    };

    // Used in the quasi-quotation below as `#name`
    let name = &ast.ident;

    // Helper is provided for handling complex generic types correctly and effortlessly
    let (impl_generics, ty_generics, where_clause) = ast.generics.split_for_impl();

    quote! {
        impl #impl_generics ::libpathfinder_common::TableNamer for #name #ty_generics #where_clause {
            fn get_table_name() -> String {
                return #table_name.to_string();
            }
        }
    }
}

fn get_table_meta_items(attr: &syn::Attribute) -> Option<Vec<syn::NestedMetaItem>> {
    match attr.value {
        List(ref name, ref items) if name == "table_namer" => Some(items.iter().cloned().collect()),
        _ => None,
    }
}

fn get_string_from_lit(attr_name: &str, meta_item_name: &str, lit: &syn::Lit) -> String {
    if let syn::Lit::Str(ref s, _) = *lit {
        s.clone()
    } else {
        panic!(format!(
            "expected table_name {} attribute to be a string: `{} = \"...\"`",
            attr_name,
            meta_item_name
        ));
    }
}

#![recursion_limit = "192"]

extern crate proc_macro;
use proc_macro::TokenStream;

extern crate syn;

#[macro_use]
extern crate quote;

mod query_params;
mod from_row;
mod table_name;

#[proc_macro_derive(QueryParam)]
pub fn query_param_macro(input: TokenStream) -> TokenStream {
    let source = input.to_string();

    // Parse the string representation into a syntax tree
    let ast = syn::parse_derive_input(&source).unwrap();

    // Build the output, possibly using quasi-quotation
    let expanded = query_params::derive_query_param(&ast);

    // Parse back to a token stream and return it
    expanded.parse().unwrap()
}

#[proc_macro_derive(FromRow)]
pub fn from_row_macro(input: TokenStream) -> TokenStream {
    let source = input.to_string();

    // Parse the string representation into a syntax tree
    let ast = syn::parse_derive_input(&source).unwrap();

    // Build the output, possibly using quasi-quotation
    let expanded = from_row::derive_from_row(&ast);

    // Parse back to a token stream and return it
    expanded.parse().unwrap()
}

#[proc_macro_derive(TableNamer, attributes(table_namer))]
pub fn table_namer_macro(input: TokenStream) -> TokenStream {
    let source = input.to_string();

    // Parse the string representation into a syntax tree
    let ast = syn::parse_derive_input(&source).unwrap();

    // Build the output, possibly using quasi-quotation
    let expanded = table_name::derive_table_namer(&ast);

    // Parse back to a token stream and return it
    expanded.parse().unwrap()
}

use quote;
use syn;

pub fn derive_from_row(ast: &syn::DeriveInput) -> quote::Tokens {
    let (field_lets, field_assignments) = match ast.body {
        syn::Body::Struct(ref data) => {
            if data.fields().len() == 0 {
                panic!("#[derive(FromRow)] must have at least one field");
            }

            let mut field_lets = Vec::new();
            let mut field_assignments = Vec::new();
            for field_syn in data.fields() {
                let field = field_syn.ident.as_ref().unwrap();
                let field_str = format!("{}", field);
                field_lets.push(quote! { let #field =
                try!(try!(row.get_opt(#field_str).ok_or(
                    error::Error::ParsingNonexistentField(#field_str.to_owned()))
                ).map_err(error::Error::Postgres)); });
                field_assignments.push(quote! { #field: #field });
            }

            (field_lets, field_assignments)
        }
        syn::Body::Enum(_) => panic!("#[derive(FromRow)] can only be used with structs"),
    };

    // Used in the quasi-quotation below as `#name`
    let name = &ast.ident;

    // Helper is provided for handling complex generic types correctly and effortlessly
    let (impl_generics, ty_generics, where_clause) = ast.generics.split_for_impl();

    quote! {
        impl #impl_generics ::libpathfinder_common::FromRow for #name #ty_generics #where_clause {
            fn parse_row(row: postgres::rows::Row) -> Result<Self, error::Error> {
                #(#field_lets)*
                return Ok(#name { #(#field_assignments),* });
            }
        }
    }
}

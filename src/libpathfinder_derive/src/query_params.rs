use quote;
use syn;

pub fn derive_query_param(ast: &syn::DeriveInput) -> quote::Tokens {
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

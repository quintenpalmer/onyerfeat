module View.Elements
    exposing
        ( panelled
        , labelDefault
        , table
        )

import Tuple
import Html
import Html.Attributes as Attr
import Common


panelled : String -> Bool -> List (Html.Html Common.Msg) -> Html.Html Common.Msg
panelled title center children =
    Html.div [ Attr.class "text-center" ] <|
        [ Html.div [ Attr.class "panel panel-default" ]
            [ Html.div [ Attr.class "panel-heading panel-small-header" ] [ Html.text title ]
            , Html.div
                ([ Attr.class "panel-body" ]
                    ++ (if center then
                            []
                        else
                            [ Attr.class "text-left" ]
                       )
                )
                children
            ]
        ]


labelDefault : Bool -> String -> Html.Html Common.Msg
labelDefault cap text =
    Html.span
        ([ Attr.class "label label-default label-large" ]
            ++ (if cap then
                    [ Attr.class "text-capitalize" ]
                else
                    []
               )
        )
        [ Html.text text ]


table : Bool -> List ( String, ( Bool, String ) ) -> Html.Html Common.Msg
table bordered pairs =
    Html.table
        [ Attr.class
            ("table table-striped"
                ++ if bordered then
                    " table-bordered"
                   else
                    ""
            )
        ]
        [ Html.thead []
            [ Html.tr [] <|
                List.map
                    (\x -> Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text x ])
                    (List.map Tuple.first pairs)
            ]
        , Html.tbody [ Attr.class "text-center" ]
            [ Html.tr [] <|
                List.map
                    (\( labelled, x ) ->
                        Html.td []
                            [ if labelled then
                                labelDefault False x
                              else
                                Html.text x
                            ]
                    )
                    (List.map Tuple.second pairs)
            ]
        ]

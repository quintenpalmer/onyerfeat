module View.Elements
    exposing
        ( panelled
        , labelDefault
        )

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


labelDefault : String -> List (Html.Html Common.Msg)
labelDefault text =
    [ Html.span [ Attr.class "label label-default label-large" ]
        [ Html.text text ]
    ]

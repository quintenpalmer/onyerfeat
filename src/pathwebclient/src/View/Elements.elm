module View.Elements
    exposing
        ( panelled
        )

import Html
import Html.Attributes as Attr
import Common


panelled : String -> Bool -> List (Html.Html Common.Msg) -> Html.Html Common.Msg
panelled title center children =
    Html.div
        (if center then
            [ Attr.class "text-center" ]
         else
            []
        )
    <|
        [ Html.div [ Attr.class "panel panel-default" ]
            [ Html.div [ Attr.class "panel-heading panel-small-header" ] [ Html.text title ]
            , Html.div [ Attr.class "panel-body" ]
                children
            ]
        ]

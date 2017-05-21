module View.DiceTab exposing (displayDiceTab)

import Html
import Html.Attributes as Attr
import Html.Events as Events
import Common
import View.Elements as Elements


displayDiceTab : Maybe Int -> Html.Html Common.Msg
displayDiceTab mRoll =
    Html.div []
        [ Html.div [ Attr.class "text-center" ] [ Html.h1 [] [ Html.text "DICE" ] ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-3" ] []
            , Html.div [ Attr.class "col-md-6" ]
                [ Elements.panelled "Dice Rolls"
                    True
                    [ Html.div []
                        [ Html.text
                            ("Roll: "
                                ++ case mRoll of
                                    Just val ->
                                        toString val

                                    Nothing ->
                                        ""
                            )
                        ]
                    , Html.div [ Attr.class "btn btn-group", Attr.style [ ( "role", "group" ) ] ] <|
                        List.map
                            (\num ->
                                Html.button [ Attr.class "btn btn-default", Events.onClick <| Common.LoadDie num ]
                                    [ Html.text <| "1d" ++ toString num ]
                            )
                            [ 2, 3, 4, 6, 8, 10, 12, 20, 100 ]
                    ]
                ]
            ]
        ]

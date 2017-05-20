module View.DiceTab exposing (displayDiceTab)

import Html
import Html.Attributes as Attr
import Html.Events as Events
import Common


displayDiceTab : Maybe Int -> Html.Html Common.Msg
displayDiceTab mRoll =
    Html.div []
        [ Html.h1 [] [ Html.text "Dice Rolls" ]
        , Html.div []
            [ Html.text <|
                "Roll: "
                    ++ case mRoll of
                        Just val ->
                            toString val

                        Nothing ->
                            ""
            ]
        , Html.div [ Attr.class "btn btn-group", Attr.style [ ( "role", "group" ) ] ] <|
            List.map
                (\num ->
                    Html.button [ Attr.class "btn btn-default", Events.onClick <| Common.LoadDie num ]
                        [ Html.text <| "1d" ++ toString num ]
                )
                [ 2, 3, 4, 6, 8, 10, 12, 20, 100 ]
        ]

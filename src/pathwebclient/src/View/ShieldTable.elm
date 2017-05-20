module View.ShieldTable exposing (displayShields)

import Html
import Html.Attributes as Attr
import Common
import Models


displayShields : List Models.Shield -> Html.Html Common.Msg
displayShields shields =
    Html.div [ Attr.class "container" ]
        [ Html.div [ Attr.class "col-md-7", Attr.class "text-center" ]
            [ Html.div [ Attr.class "panel panel-default" ]
                [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Shields" ] ]
                , Html.div [ Attr.class "panel-body" ]
                    [ Html.table [ Attr.class "table table-striped" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "AC Bonus" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Max Dex" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Skill Penalty" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Arcane Spell Failure Chance" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Weight" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            (List.map
                                (\shield ->
                                    Html.tr []
                                        [ Html.td [ Attr.class "text-left" ]
                                            [ Html.text shield.name ]
                                        , Html.td []
                                            [ Html.text <| toString shield.acBonus ]
                                        , Html.td []
                                            [ Html.text <|
                                                case shield.maxDex of
                                                    Nothing ->
                                                        "_"

                                                    Just maxDex ->
                                                        toString maxDex
                                            ]
                                        , Html.td []
                                            [ Html.text <| toString shield.skillPenalty ]
                                        , Html.td []
                                            [ Html.text <| toString shield.arcaneSpellFailureChance ]
                                        , Html.td []
                                            [ Html.text <| toString shield.weight ]
                                        ]
                                )
                                shields
                            )
                        ]
                    ]
                ]
            ]
        ]

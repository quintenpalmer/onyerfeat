module View.ShieldTable exposing (displayShields)

import Html
import Html.Attributes as Attr
import Common
import Models
import View.Elements as Elements


displayShields : List Models.Shield -> Html.Html Common.Msg
displayShields shields =
    Html.div []
        [ Html.div [ Attr.class "text-center" ] [ Html.h1 [] [ Html.text "SHIELDS" ] ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-2" ] []
            , Html.div [ Attr.class "col-md-8" ]
                [ Elements.panelled "Shield Table"
                    True
                    [ Html.table [ Attr.class "table table-striped table-bordered" ]
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

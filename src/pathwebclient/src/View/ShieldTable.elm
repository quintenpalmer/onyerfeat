module View.ShieldTable exposing (displayShields)

import Html
import Html.Attributes as Attr
import Common
import Models
import View.Elements as Elements
import View.Formatting as Formatting


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
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Style" ]
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
                                        [ Html.td [ Attr.class "text-left" ] [ Elements.labelDefault False shield.name ]
                                        , Html.td []
                                            [ Elements.labelDefault False
                                                (case shield.sizeStyle of
                                                    Just sizeStyle ->
                                                        (String.join " " (List.map Formatting.capitalize (String.split "_" sizeStyle)))

                                                    Nothing ->
                                                        "-"
                                                )
                                            ]
                                        , Html.td [] [ Elements.labelDefault True <| toString shield.acBonus ]
                                        , Html.td []
                                            [ Elements.labelDefault True <|
                                                case shield.maxDex of
                                                    Nothing ->
                                                        "_"

                                                    Just maxDex ->
                                                        toString maxDex
                                            ]
                                        , Html.td [] [ Elements.labelDefault True <| toString shield.skillPenalty ]
                                        , Html.td [] [ Elements.labelDefault True <| toString shield.arcaneSpellFailureChance ]
                                        , Html.td [] [ Elements.labelDefault True <| toString shield.weight ]
                                        ]
                                )
                                shields
                            )
                        ]
                    ]
                ]
            ]
        ]

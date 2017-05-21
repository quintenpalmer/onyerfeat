module View.ArmorTable exposing (displayArmorPieces)

import Html
import Html.Attributes as Attr
import Common
import Models
import View.Elements as Elements


displayArmorPieces : List Models.ArmorPiece -> Html.Html Common.Msg
displayArmorPieces armorPieces =
    Html.div []
        [ Html.div [ Attr.class "text-center" ] [ Html.h1 [] [ Html.text "ARMOR PIECES" ] ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-1" ] []
            , Html.div [ Attr.class "col-md-10" ]
                [ Elements.panelled "Armor Table"
                    True
                    [ Html.table [ Attr.class "table table-striped table-bordered" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Armor Class" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Armor Bonus" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Max Dex Bonus" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Armor Check Penalty" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Arcane Spell Failure Chance" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Fast Speed" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Slow Speed" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Medium Weight" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            (List.map
                                (\piece ->
                                    Html.tr []
                                        [ Html.td [] [ Html.b [] [ Html.text piece.armorClass ] ]
                                        , Html.td [] [ Html.b [] [ Html.text piece.name ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.armorBonus ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.maxDexBonus ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.armorCheckPenalty ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.arcaneSpellFailureChance ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.fastSpeed ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.slowSpeed ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString piece.mediumWeight ] ]
                                        ]
                                )
                                armorPieces
                            )
                        ]
                    ]
                ]
            ]
        ]

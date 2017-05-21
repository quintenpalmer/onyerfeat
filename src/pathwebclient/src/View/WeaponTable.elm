module View.WeaponTable exposing (displayWeapons)

import Html
import Html.Attributes as Attr
import Common
import Models
import View.Elements as Elements


displayWeapons : List Models.Weapon -> Html.Html Common.Msg
displayWeapons weapons =
    Html.div []
        [ Html.div [ Attr.class "text-center" ] [ Html.h1 [] [ Html.text "WEAPONS" ] ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-1" ] []
            , Html.div [ Attr.class "col-md-10" ]
                [ Elements.panelled "Weapons Table"
                    True
                    [ Html.table [ Attr.class "table table-striped table-bordered" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Training Type" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Style" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Cost" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Damage (small)" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Damage (med)" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Critical" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Range" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Weight" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Damage Type" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            (List.map
                                (\weapon ->
                                    Html.tr []
                                        [ Html.td [] [ Html.b [] [ Html.text weapon.name ] ]
                                        , Html.td [] [ Html.b [ Attr.class "text-capitalize" ] [ Html.text weapon.trainingType ] ]
                                        , Html.td [] [ Html.b [ Attr.class "text-capitalize" ] [ Html.text <| (String.join " " (String.split "_" weapon.sizeStyle)) ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| (toString weapon.cost) ++ "gp" ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| displayDice weapon.smallDamage ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| displayDice weapon.mediumDamage ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| displayCriticalDamage weapon.critical ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| toString weapon.range ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| (toString weapon.weight) ++ "lbs" ] ]
                                        , Html.td [] [ Html.b [] [ Html.text <| displayPhysicalDamage weapon.damageType ] ]
                                        ]
                                )
                                weapons
                            )
                        ]
                    ]
                ]
            ]
        ]


displayDice : Models.DiceDamage -> String
displayDice dice =
    (toString dice.numDice) ++ "d" ++ (toString dice.dieSize)


displayCriticalDamage : Models.CriticalDamage -> String
displayCriticalDamage crit =
    (if crit.requiredRoll == 20 then
        "20"
     else
        (toString crit.requiredRoll) ++ "-20"
    )
        ++ "/x"
        ++ (toString crit.multiplier)


displayPhysicalDamage : Models.PhysicalDamageType -> String
displayPhysicalDamage phys =
    let
        all =
            []
                ++ (if phys.bludgeoning then
                        [ "B" ]
                    else
                        []
                   )
                ++ (if phys.piercing then
                        [ "P" ]
                    else
                        []
                   )
                ++ (if phys.slashing then
                        [ "S" ]
                    else
                        []
                   )

        join =
            if phys.andTogether then
                " and "
            else
                " or "
    in
        case all of
            [] ->
                "?"

            [ x ] ->
                x

            _ ->
                String.join join all

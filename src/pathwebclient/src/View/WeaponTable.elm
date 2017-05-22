module View.WeaponTable exposing (displayWeapons, weaponsPanel)

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
                [ weaponsPanel weapons ]
            ]
        ]


weaponsPanel : List Models.Weapon -> Html.Html Common.Msg
weaponsPanel weapons =
    Elements.panelled "Weapons Table"
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
                            [ Html.td [ Attr.class "text-left" ] [ Elements.labelDefault False weapon.name ]
                            , Html.td [] [ Elements.labelDefault True weapon.trainingType ]
                            , Html.td [] [ Elements.labelDefault True <| (String.join " " (String.split "_" weapon.sizeStyle)) ]
                            , Html.td [] [ Elements.labelDefault True <| (toString weapon.cost) ++ "gp" ]
                            , Html.td [] [ Elements.labelDefault True <| displayDice weapon.smallDamage ]
                            , Html.td [] [ Elements.labelDefault True <| displayDice weapon.mediumDamage ]
                            , Html.td [] [ Elements.labelDefault False <| displayCriticalDamage weapon.critical ]
                            , Html.td [] [ Elements.labelDefault True <| (toString weapon.range) ++ "ft" ]
                            , Html.td [] [ Elements.labelDefault True <| (toString weapon.weight) ++ "lbs" ]
                            , Html.td [] [ Elements.labelDefault False <| displayPhysicalDamage weapon.damageType ]
                            ]
                    )
                    weapons
                )
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

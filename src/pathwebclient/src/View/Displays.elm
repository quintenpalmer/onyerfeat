module View.Displays
    exposing
        ( displayDice
        , displayCriticalDamage
        , displayPhysicalDamage
        )

import Models


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

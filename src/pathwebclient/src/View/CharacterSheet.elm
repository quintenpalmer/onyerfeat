module View.CharacterSheet exposing (displayCharacterSheet)

import Char
import Html
import Html.Attributes as Attr
import Common
import Models
import View.Elements as Elements


displayCharacterSheet : Models.Character -> Html.Html Common.Msg
displayCharacterSheet character =
    Html.div []
        [ Html.div [ Attr.class "text-center" ] [ Html.h1 [] [ Html.text "CHARACTER SHEET" ] ]
        , Html.div [ Attr.class "row" ]
            [ Elements.panelled "Meta Information"
                True
                [ Elements.table True
                    [ ( "character name", ( True, character.metaInformation.name ) )
                    , ( "player name", ( True, character.metaInformation.playerName ) )
                    , ( "alignment", ( True, capitalize character.metaInformation.alignment.order ++ " " ++ capitalize character.metaInformation.alignment.morality ) )
                    , ( "race", ( True, capitalize character.metaInformation.race ) )
                    , ( "class", ( True, capitalize character.metaInformation.class ) )
                    , ( "class level", ( True, toString character.level ) )
                    , ( "size", ( True, toString character.metaInformation.size ) )
                    , ( "age", ( True, toString character.metaInformation.age ) )
                    , ( "deity"
                      , ( True
                        , capitalize <|
                            case character.metaInformation.deity of
                                Just s ->
                                    s

                                Nothing ->
                                    "_"
                        )
                      )
                    ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-5" ]
                [ Elements.panelled "Ability Scores"
                    True
                    [ Html.table [ Attr.class "table table-striped table-bordered" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Score" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Modifier" ]
                                , Html.th [ Attr.class "text-right" ] [ Html.text "-EModji" ]
                                , Html.th [ Attr.class "text-left" ] [ Html.text "EModji" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            [ scoreTableRow "STR" character.abilityScores.str "🐂"
                            , scoreTableRow "DEX" character.abilityScores.dex "🐆"
                            , scoreTableRow "CON" character.abilityScores.con "🐘"
                            , scoreTableRow "INT" character.abilityScores.int "🐙"
                            , scoreTableRow "WIS" character.abilityScores.wis "\x1F989"
                            , scoreTableRow "CHA" character.abilityScores.cha "🐶"
                            ]
                        ]
                    ]
                , Elements.panelled "Hit Points"
                    True
                    [ Html.table [ Attr.class "table table-striped table-bordered" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Current" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Max" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Nonlethal" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            [ Html.tr []
                                [ Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.currentHitPoints) ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.currentHitPoints) ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.nonlethalDamage) ]
                                    ]
                                ]
                            ]
                        ]
                    , Html.h4 []
                        [ Html.small []
                            [ Html.text <|
                                String.append
                                    (String.repeat
                                        (round
                                            (toFloat character.combatNumbers.currentHitPoints
                                                * (20.0 / toFloat character.combatNumbers.maxHitPoints)
                                            )
                                        )
                                        "⬛"
                                    )
                                    (String.repeat
                                        (round
                                            (toFloat (character.combatNumbers.maxHitPoints - character.combatNumbers.currentHitPoints)
                                                * (20.0 / toFloat character.combatNumbers.maxHitPoints)
                                            )
                                        )
                                        "⬜"
                                    )
                            ]
                        ]
                    ]
                , Elements.panelled "Armor Class"
                    True
                    [ Elements.table False
                        [ ( "Total", ( True, toString character.combatNumbers.armorClass.total ) )
                        , ( "Base", ( False, "10" ) )
                        , ( "Dex", ( True, toString character.combatNumbers.armorClass.dex ) )
                        , ( "Armor", ( True, toString character.combatNumbers.armorClass.armorAc ) )
                        , ( "Shield", ( True, toString character.combatNumbers.armorClass.shieldAc ) )
                        , ( "Size", ( True, toString character.combatNumbers.armorClass.sizeMod ) )
                        ]
                    ]
                , Elements.panelled "Saving Throws"
                    True
                    [ Html.table [ Attr.class "table table-striped" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Total" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Base" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Mod" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Name" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            (List.map
                                (\( name, throw ) ->
                                    Html.tr []
                                        [ Html.td [ Attr.class "text-left" ]
                                            [ Html.b [ Attr.class "text-capitalize" ]
                                                [ Html.text name ]
                                            ]
                                        , Html.td []
                                            [ Html.span [ Attr.class "label label-default" ]
                                                [ Html.text (toString throw.total) ]
                                            ]
                                        , Html.td []
                                            [ Html.span [ Attr.class "label label-default" ]
                                                [ Html.text (toString throw.base) ]
                                            ]
                                        , Html.td []
                                            [ Html.span [ Attr.class "label label-default" ]
                                                [ Html.text (toString throw.abilityMod) ]
                                            ]
                                        , Html.td []
                                            [ Html.b [ Attr.class "text-uppercase" ]
                                                [ Html.text throw.abilityName ]
                                            ]
                                        ]
                                )
                                [ ( "fortitude", character.combatNumbers.savingThrows.fortitude )
                                , ( "reflex", character.combatNumbers.savingThrows.reflex )
                                , ( "will", character.combatNumbers.savingThrows.will )
                                ]
                            )
                        ]
                    ]
                , Elements.panelled "Base Attack Bonus"
                    True
                    [ Html.h2 []
                        [ Html.div [ Attr.class "label label-default" ]
                            [ Html.text <| toString character.combatNumbers.baseAttackBonus ]
                        ]
                    ]
                , Elements.panelled "Combat Maneuvers"
                    True
                    [ Html.div []
                        [ Html.div []
                            [ Html.h4 [] [ Html.text "Combat Maneuver Bonus" ]
                            , Elements.table False
                                [ ( "total", ( True, toString character.combatNumbers.combatManeuvers.bonus.total ) )
                                , ( "str", ( True, toString character.combatNumbers.combatManeuvers.bonus.str ) )
                                , ( "base attack", ( True, toString character.combatNumbers.combatManeuvers.bonus.baseAttackBonus ) )
                                , ( "size modifier", ( True, toString character.combatNumbers.combatManeuvers.bonus.sizeMod ) )
                                ]
                            ]
                        , Html.div []
                            [ Html.h4 [] [ Html.text "Combat Maneuver Defense" ]
                            , Elements.table False
                                [ ( "total", ( True, toString character.combatNumbers.combatManeuvers.defense.total ) )
                                , ( "base", ( False, toString character.combatNumbers.combatManeuvers.defense.base ) )
                                , ( "str", ( True, toString character.combatNumbers.combatManeuvers.defense.str ) )
                                , ( "dex", ( True, toString character.combatNumbers.combatManeuvers.defense.dex ) )
                                , ( "base attack", ( True, toString character.combatNumbers.combatManeuvers.defense.baseAttackBonus ) )
                                , ( "size modifier", ( True, toString character.combatNumbers.combatManeuvers.defense.sizeMod ) )
                                ]
                            ]
                        ]
                    ]
                ]
            , Html.div [ Attr.class "col-md-7" ]
                [ Elements.panelled "Skills"
                    True
                    [ Html.table [ Attr.class "table table-striped" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Bonus" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Mod" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Name" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Class Skill (+3)" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Ranks" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Armor Check Penalty" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            (List.map
                                (\skill ->
                                    Html.tr []
                                        [ Html.td [ Attr.class "text-left" ]
                                            [ Html.b []
                                                [ Html.text <| buildSkillName skill ]
                                            ]
                                        , Html.td []
                                            [ Html.span [ Attr.class "label label-default" ]
                                                [ Html.text (toString skill.total) ]
                                            ]
                                        , Html.td []
                                            [ Html.span [ Attr.class "label label-default" ]
                                                [ Html.text (toString skill.abilityMod) ]
                                            ]
                                        , Html.td []
                                            [ Html.b [ Attr.class "text-uppercase" ]
                                                [ Html.text skill.ability ]
                                            ]
                                        , Html.td []
                                            [ Html.text <|
                                                if skill.isClassSkill then
                                                    "⬛"
                                                else
                                                    "⬜"
                                            ]
                                        , Html.td []
                                            [ if skill.count > 0 then
                                                Html.span [ Attr.class "label label-default" ]
                                                    [ Html.text (toString skill.count) ]
                                              else
                                                Html.u [] [ Html.text "_" ]
                                            ]
                                        , Html.td []
                                            [ case skill.armorCheckPenalty of
                                                Just pen ->
                                                    Html.span [ Attr.class "label label-default" ]
                                                        [ Html.text (toString pen) ]

                                                Nothing ->
                                                    Html.u [] [ Html.text "_" ]
                                            ]
                                        ]
                                )
                                character.skills
                            )
                        ]
                    ]
                ]
            ]
        , Html.div
            [ Attr.class "row" ]
            [ Elements.panelled "Armor Piece"
                False
                [ Elements.table True
                    [ ( "name", ( True, character.armorPiece.name ) )
                    , ( "class", ( True, character.armorPiece.armorClass ) )
                    , ( "AC bonus", ( True, "+" ++ (toString character.armorPiece.armorBonus) ) )
                    , ( "max dex", ( True, "+" ++ (toString character.armorPiece.maxDexBonus) ) )
                    , ( "skill penalty", ( True, toString character.armorPiece.armorCheckPenalty ) )
                    , ( "spell failure", ( True, (toString character.armorPiece.arcaneSpellFailureChance) ++ "%" ) )
                    , ( "fast speed", ( True, (toString character.armorPiece.fastSpeed) ++ "ft" ) )
                    , ( "slow speed", ( True, (toString character.armorPiece.slowSpeed) ++ "ft" ) )
                    , ( "weight", ( True, (toString character.armorPiece.mediumWeight) ++ "lbs" ) )
                    ]
                ]
            , Elements.panelled "Shield"
                False
                [ case character.shield of
                    Nothing ->
                        Html.div [] [ Html.text "no shield" ]

                    Just shield ->
                        Elements.table True
                            [ ( "name", ( True, shield.name ) )
                            , ( "AC bonus", ( True, "+" ++ (toString shield.acBonus) ) )
                            , ( "max dex"
                              , ( True
                                , case shield.maxDex of
                                    Just maxDex ->
                                        "+" ++ (toString shield.maxDex)

                                    Nothing ->
                                        "_"
                                )
                              )
                            , ( "skill penalty", ( True, toString shield.skillPenalty ) )
                            , ( "spell failure", ( True, (toString shield.arcaneSpellFailureChance) ++ "%" ) )
                            , ( "weight", ( True, (toString shield.weight) ++ "lbs" ) )
                            ]
                ]
            ]
        ]


capitalize : String -> String
capitalize string =
    case String.uncons string of
        Nothing ->
            ""

        Just ( head, tail ) ->
            String.cons (Char.toUpper head) tail


buildSkillName : Models.Skill -> String
buildSkillName skill =
    case skill.sub_name of
        Nothing ->
            capitalize skill.name

        Just sub_name ->
            capitalize skill.name ++ " (" ++ capitalize sub_name ++ ")"


scoreTableRow : String -> Models.Ability -> String -> Html.Html Common.Msg
scoreTableRow name ability emoji =
    Html.tr []
        [ Html.td [] [ Html.b [] [ Html.text name ] ]
        , Html.td []
            [ Html.span [ Attr.class "label label-default" ]
                [ Html.text (toString ability.score) ]
            ]
        , Html.td []
            [ Html.span [ Attr.class "label label-default" ]
                [ Html.b [] [ Html.text (toString ability.modifier) ] ]
            ]
        , Html.td [ Attr.class "text-right" ]
            [ Html.text <|
                if ability.modifier < 0 then
                    String.repeat (-ability.modifier) emoji
                else
                    ""
            ]
        , Html.td [ Attr.class "text-left" ]
            [ Html.text <|
                if ability.modifier > 0 then
                    String.repeat (ability.modifier) emoji
                else
                    ""
            ]
        ]

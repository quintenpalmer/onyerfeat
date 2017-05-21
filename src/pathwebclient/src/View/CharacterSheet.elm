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
                    [ ( "Character Name", character.metaInformation.name )
                    , ( "Player name", character.metaInformation.playerName )
                    , ( "Alignment", capitalize character.metaInformation.alignment.order ++ " " ++ capitalize character.metaInformation.alignment.morality )
                    , ( "Race", capitalize character.metaInformation.race )
                    , ( "Class", capitalize character.metaInformation.class )
                    , ( "Class Level", toString character.level )
                    , ( "Size", toString character.metaInformation.size )
                    , ( "Age", toString character.metaInformation.age )
                    , ( "Deity"
                      , capitalize <|
                            case character.metaInformation.deity of
                                Just s ->
                                    s

                                Nothing ->
                                    "_"
                      )
                    ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-5" ]
                [ Elements.panelled "Ability Scores"
                    True
                    [ Html.table [ Attr.class "table table-striped" ]
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
                                        (character.combatNumbers.currentHitPoints)
                                        "⬛"
                                    )
                                    (String.repeat
                                        (character.combatNumbers.maxHitPoints - character.combatNumbers.currentHitPoints)
                                        "⬜"
                                    )
                            ]
                        ]
                    ]
                , Elements.panelled "Armor Class"
                    True
                    [ Html.table [ Attr.class "table table-striped" ]
                        [ Html.thead []
                            [ Html.tr []
                                [ Html.th [ Attr.class "text-center" ] [ Html.text "Total" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Base" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Dex" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Armor" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Shield" ]
                                , Html.th [ Attr.class "text-center" ] [ Html.text "Size" ]
                                ]
                            ]
                        , Html.tbody [ Attr.class "text-center" ]
                            [ Html.tr []
                                [ Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.armorClass.total) ]
                                    ]
                                , Html.td []
                                    [ Html.span []
                                        [ Html.text "10" ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.armorClass.dex) ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.armorClass.armorAc) ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.armorClass.shieldAc) ]
                                    ]
                                , Html.td []
                                    [ Html.span [ Attr.class "label label-default" ]
                                        [ Html.text (toString character.combatNumbers.armorClass.sizeMod) ]
                                    ]
                                ]
                            ]
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
                [ Html.table [ Attr.class "table table-striped table-bordered" ]
                    [ Html.thead []
                        [ Html.tr []
                            [ Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "name" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "class" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "AC bonus" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "max dex" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "skill penalty" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "spell failure" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "fast speed" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "slow speed" ]
                            , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "weight" ]
                            ]
                        ]
                    , Html.tbody [ Attr.class "text-center" ]
                        [ Html.tr []
                            [ Html.td [] <| Elements.labelDefault character.armorPiece.name
                            , Html.td [] <| Elements.labelDefault character.armorPiece.armorClass
                            , Html.td [] <| Elements.labelDefault <| "+" ++ (toString character.armorPiece.armorBonus)
                            , Html.td [] <| Elements.labelDefault <| "+" ++ (toString character.armorPiece.maxDexBonus)
                            , Html.td [] <| Elements.labelDefault <| toString character.armorPiece.armorCheckPenalty
                            , Html.td [] <| Elements.labelDefault <| (toString character.armorPiece.arcaneSpellFailureChance) ++ "%"
                            , Html.td [] <| Elements.labelDefault <| (toString character.armorPiece.fastSpeed) ++ "ft"
                            , Html.td [] <| Elements.labelDefault <| (toString character.armorPiece.slowSpeed) ++ "ft"
                            , Html.td [] <| Elements.labelDefault <| (toString character.armorPiece.mediumWeight) ++ "lbs"
                            ]
                        ]
                    ]
                ]
            , Elements.panelled "Shield"
                False
                [ case character.shield of
                    Nothing ->
                        Html.div [] [ Html.text "no shield" ]

                    Just shield ->
                        Html.table [ Attr.class "table table-striped table-bordered" ]
                            [ Html.thead []
                                [ Html.tr []
                                    [ Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "name" ]
                                    , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "AC bonus" ]
                                    , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "max dex" ]
                                    , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "skill penalty" ]
                                    , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "spell failure" ]
                                    , Html.th [ Attr.class "text-center text-capitalize" ] [ Html.text "weight" ]
                                    ]
                                ]
                            , Html.tbody [ Attr.class "text-center" ]
                                [ Html.tr []
                                    [ Html.td [] <| Elements.labelDefault shield.name
                                    , Html.td [] <| Elements.labelDefault <| "+" ++ (toString shield.acBonus)
                                    , Html.td [] <|
                                        Elements.labelDefault <|
                                            case shield.maxDex of
                                                Just maxDex ->
                                                    "+" ++ (toString shield.maxDex)

                                                Nothing ->
                                                    "_"
                                    , Html.td [] <| Elements.labelDefault <| toString shield.skillPenalty
                                    , Html.td [] <| Elements.labelDefault <| (toString shield.arcaneSpellFailureChance) ++ "%"
                                    , Html.td [] <| Elements.labelDefault <| (toString shield.weight) ++ "lbs"
                                    ]
                                ]
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

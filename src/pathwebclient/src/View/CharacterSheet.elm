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
        [ Html.h1 [ Attr.class "text-center" ] [ Html.text "Welcome!" ]
        , Html.p [ Attr.class "text-center" ] [ Html.text <| "Hello, " ++ character.metaInformation.name ++ "! Good to see ya!" ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-6" ]
                [ Html.h1 [] [ Html.text "CHARACTER SHEET" ] ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text character.metaInformation.name ]
                , Html.p [] [ Html.small [] [ Html.text "Character name" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.metaInformation.alignment.order ++ " " ++ capitalize character.metaInformation.alignment.morality ]
                , Html.p [] [ Html.small [] [ Html.text "Alignment" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text character.metaInformation.playerName ]
                , Html.p [] [ Html.small [] [ Html.text "Player name" ] ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-6" ] []
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| toString character.level ]
                , Html.p [] [ Html.small [] [ Html.text "Character/Class Level" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.metaInformation.class ]
                , Html.p [] [ Html.small [] [ Html.text "Class" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.metaInformation.race ]
                , Html.p [] [ Html.small [] [ Html.text "Race" ] ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-6" ] []
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| toString character.metaInformation.age ]
                , Html.p [] [ Html.small [] [ Html.text "Age" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| toString character.metaInformation.size ]
                , Html.p [] [ Html.small [] [ Html.text "Size" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u []
                    [ Html.text <|
                        capitalize <|
                            case character.metaInformation.deity of
                                Just s ->
                                    s

                                Nothing ->
                                    "_"
                    ]
                , Html.p [] [ Html.small [] [ Html.text "Deity" ] ]
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
                , Html.div [ Attr.class "text-center" ]
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Hit Points" ] ]
                        , Html.div [ Attr.class "panel-body" ]
                            [ Html.h4 []
                                [ displayField "100px" "current" <| toString character.combatNumbers.currentHitPoints
                                , Html.text "➗"
                                , displayField "100px" "max" <| toString character.combatNumbers.maxHitPoints
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
                            , Html.h4 []
                                [ displayField "100px" "nonlethal" <| toString character.combatNumbers.nonlethalDamage
                                ]
                            ]
                        ]
                    ]
                , Html.div [ Attr.class "text-center" ]
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Armor Class" ] ]
                        , Html.div [ Attr.class "panel-body" ]
                            [ Html.h4 []
                                [ Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [ Attr.class "label label-default" ]
                                        [ Html.text <| toString character.combatNumbers.armorClass.total ]
                                    , Html.div [] [ Html.text "Total" ]
                                    ]
                                , Html.div [ Attr.style [ ( "vertical-align", "top" ), ( "width", "20px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "=" ]
                                    ]
                                , Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "10" ]
                                    , Html.div [] [ Html.text "Base" ]
                                    ]
                                , Html.div [ Attr.style [ ( "vertical-align", "top" ), ( "width", "20px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "+" ]
                                    ]
                                , Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [ Attr.class "label label-default" ]
                                        [ Html.text <| toString character.combatNumbers.armorClass.dex ]
                                    , Html.div [] [ Html.text "Dex" ]
                                    ]
                                , Html.div [ Attr.style [ ( "vertical-align", "top" ), ( "width", "20px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "+" ]
                                    ]
                                , Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [ Attr.class "label label-default" ]
                                        [ Html.text <| toString character.combatNumbers.armorClass.armorAc ]
                                    , Html.div [] [ Html.text "Armor" ]
                                    ]
                                , Html.div [ Attr.style [ ( "vertical-align", "top" ), ( "width", "20px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "+" ]
                                    ]
                                , Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [ Attr.class "label label-default" ]
                                        [ Html.text <| toString character.combatNumbers.armorClass.shieldAc ]
                                    , Html.div [] [ Html.text "Shield" ]
                                    ]
                                , Html.div [ Attr.style [ ( "vertical-align", "top" ), ( "width", "20px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [] [ Html.text "+" ]
                                    ]
                                , Html.div [ Attr.style [ ( "width", "50px" ), ( "display", "inline-block" ) ] ]
                                    [ Html.div [ Attr.class "label label-default" ]
                                        [ Html.text <| toString character.combatNumbers.armorClass.sizeMod ]
                                    , Html.div [] [ Html.text "Size" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , Html.div [ Attr.class "text-center" ]
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Saving Throws" ] ]
                        , Html.div [ Attr.class "panel-body" ]
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
                        ]
                    ]
                , Html.div [ Attr.class "text-center" ]
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Base Attack Bonus" ] ]
                        , Html.div [ Attr.class "panel-body" ]
                            [ Html.h2 []
                                [ Html.div [ Attr.class "label label-default" ]
                                    [ Html.text <| toString character.combatNumbers.baseAttackBonus ]
                                ]
                            ]
                        ]
                    ]
                , case character.shield of
                    Nothing ->
                        Html.div [] [ Html.text "no shield" ]

                    Just shield ->
                        Html.div []
                            [ Html.div [ Attr.class "panel panel-default" ]
                                [ Html.div [ Attr.class "panel-heading", Attr.class "text-center" ] [ Html.h3 [] [ Html.text "Shield" ] ]
                                , Html.div [ Attr.class "panel-body" ]
                                    [ Html.div []
                                        [ displayField "160px" "name" shield.name
                                        ]
                                    , Html.div []
                                        [ displayField "100px" "AC bonus" <| "+" ++ (toString shield.acBonus)
                                        , displayField "100px" "max dex" <|
                                            case shield.maxDex of
                                                Just maxDex ->
                                                    "+" ++ (toString shield.maxDex)

                                                Nothing ->
                                                    "_"
                                        , displayField "100px" "skill penalty" <| toString shield.skillPenalty
                                        ]
                                    , Html.div []
                                        [ displayField "100px" "spell failure" <| (toString shield.arcaneSpellFailureChance) ++ "%"
                                        , displayField "100px" "weight" <| (toString shield.weight) ++ "lbs"
                                        ]
                                    ]
                                ]
                            ]
                , Html.div []
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading", Attr.class "text-center" ] [ Html.h3 [] [ Html.text "Armor Piece" ] ]
                        , Html.div [ Attr.class "panel-body" ]
                            [ Html.div []
                                [ displayField "100px" "name" character.armorPiece.name
                                , displayField "100px" "class" character.armorPiece.armorClass
                                ]
                            , Html.div []
                                [ displayField "100px" "AC bonus" <| "+" ++ (toString character.armorPiece.armorBonus)
                                , displayField "100px" "max dex" <| "+" ++ (toString character.armorPiece.maxDexBonus)
                                , displayField "100px" "skill penalty" <| toString character.armorPiece.armorCheckPenalty
                                ]
                            , Html.div []
                                [ displayField "100px" "spell failure" <| (toString character.armorPiece.arcaneSpellFailureChance) ++ "%"
                                , displayField "100px" "weight" <| (toString character.armorPiece.mediumWeight) ++ "lbs"
                                ]
                            , Html.div []
                                [ displayField "100px" "fast speed" <| (toString character.armorPiece.fastSpeed) ++ "ft"
                                , displayField "100px" "slow speed" <| (toString character.armorPiece.slowSpeed) ++ "ft"
                                ]
                            ]
                        ]
                    ]
                ]
            , Html.div [ Attr.class "col-md-7", Attr.class "text-center" ]
                [ Html.div [ Attr.class "panel panel-default" ]
                    [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Skills" ] ]
                    , Html.div [ Attr.class "panel-body" ]
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


displayField : String -> String -> String -> Html.Html Common.Msg
displayField width key val =
    Html.div [ Attr.class "panel panel-default", Attr.style [ ( "display", "inline-block" ) ] ]
        [ Html.div [ Attr.class "panel-body", Attr.class "text-center", Attr.style [ ( "padding", "5px" ), ( "width", width ) ] ]
            [ Html.div [ Attr.class "text-capitalize", Attr.class "label label-default" ] [ Html.text val ]
            , Html.div [ Attr.class "text-capitalize" ]
                [ Html.small []
                    [ Html.text key ]
                ]
            ]
        ]

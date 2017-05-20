module View exposing (view)

import Css
import Html exposing (div)
import Html.Attributes as Attr
import Html.Events as Events
import Char
import Common
import Models


cssStyle =
    Css.asPairs >> Attr.style


fullPage =
    cssStyle
        [ Css.fontFamilies [ "Inconsolata" ]
        ]


header =
    cssStyle
        [ Css.padding <| Css.px 20
        , Css.color <| Css.rgb 250 250 250
        , Css.backgroundColor <| Css.rgb 70 70 70
        ]


view : Models.Model -> Html.Html Common.Msg
view model =
    div
        [ fullPage
        ]
        [ Html.node "link" [ Attr.rel "stylesheet", Attr.href "/assets/bootstrap/css/bootstrap.min.css" ] []
        , div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , div [ Attr.class "container" ]
            [ Html.ul [ Attr.class "nav nav-pills" ]
                [ Html.li
                    (case model of
                        Models.MCharacter _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick <| Common.LoadCharacter 1 ] [ Html.text "Load Idrigoth" ] ]
                , Html.li
                    (case model of
                        Models.MShields _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.LoadShields ] [ Html.text "Load Shields" ] ]
                , Html.li
                    (case model of
                        Models.MArmorPieces _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.LoadArmorPieces ] [ Html.text "Load Armor" ] ]
                , Html.li
                    (case model of
                        Models.MDiceTab _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.DiceTab ] [ Html.text "Dice Rolls" ] ]
                ]
            , case model of
                Models.MCharacter c ->
                    innerPage c

                Models.MError e ->
                    Html.h1 [] [ Html.text e ]

                Models.MNotLoaded ->
                    Html.h1 [] [ Html.text "Loading" ]

                Models.MShields ss ->
                    displayShields ss

                Models.MArmorPieces pieces ->
                    displayArmorPieces pieces

                Models.MDiceTab mRoll ->
                    displayDiceTab mRoll
            ]
        ]


innerPage : Models.Character -> Html.Html Common.Msg
innerPage character =
    div []
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
                [ Html.div [ Attr.class "text-center" ]
                    [ Html.div [ Attr.class "panel panel-default" ]
                        [ Html.div [ Attr.class "panel-heading" ] [ Html.h3 [] [ Html.text "Ability Scores" ] ]
                        , Html.div [ Attr.class "panel-body" ]
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


displayArmorPieces : List Models.ArmorPiece -> Html.Html Common.Msg
displayArmorPieces armorPieces =
    Html.div [ Attr.class "col-md-9" ]
        [ Html.h2 [ Attr.class "text-center" ] [ Html.text "Armor" ]
        , Html.table [ Attr.class "table table-striped table-bordered" ]
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


displayDiceTab : Maybe Int -> Html.Html Common.Msg
displayDiceTab mRoll =
    Html.div []
        [ Html.h1 [] [ Html.text "Dice Rolls" ]
        , Html.div []
            [ Html.text <|
                "Roll: "
                    ++ case mRoll of
                        Just val ->
                            toString val

                        Nothing ->
                            ""
            ]
        , Html.div [ Attr.class "btn btn-group", Attr.style [ ( "role", "group" ) ] ] <|
            List.map
                (\num ->
                    Html.button [ Attr.class "btn btn-default", Events.onClick <| Common.LoadDie num ]
                        [ Html.text <| "1d" ++ toString num ]
                )
                [ 2, 3, 4, 6, 8, 10, 12, 20, 100 ]
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

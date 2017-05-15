module View exposing (view)

import Css
import Html exposing (div)
import Html.Attributes as Attr
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
        [ Html.node "link" [ Attr.rel "stylesheet", Attr.href "assets/bootstrap/css/bootstrap.min.css" ] []
        , div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , div [ Attr.class "container" ]
            [ case model of
                Models.MCharacter c ->
                    innerPage c

                Models.MError e ->
                    Html.h1 [] [ Html.text e ]

                Models.MNotLoaded ->
                    Html.h1 [] [ Html.text "Loading" ]
            ]
        ]


innerPage : Models.Character -> Html.Html Common.Msg
innerPage character =
    div []
        [ Html.h1 [ Attr.class "text-center" ] [ Html.text "Welcome!" ]
        , Html.p [ Attr.class "text-center" ] [ Html.text <| "Hello, " ++ character.name ++ "! Good to see ya!" ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-6" ]
                [ Html.h1 [] [ Html.text "CHARACTER SHEET" ] ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text character.name ]
                , Html.p [] [ Html.small [] [ Html.text "Character name" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.alignment.order ++ " " ++ capitalize character.alignment.morality ]
                , Html.p [] [ Html.small [] [ Html.text "Alignment" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text character.playerName ]
                , Html.p [] [ Html.small [] [ Html.text "Player name" ] ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-6" ] []
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.metaInformation.class ]
                , Html.p [] [ Html.small [] [ Html.text "Class" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| capitalize character.metaInformation.race ]
                , Html.p [] [ Html.small [] [ Html.text "Race" ] ]
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
            [ Html.div [ Attr.class "col-md-6" ] []
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| toString character.metaInformation.age ]
                , Html.p [] [ Html.small [] [ Html.text "Age" ] ]
                ]
            , Html.div [ Attr.class "col-md-2" ]
                [ Html.u [] [ Html.text <| toString character.metaInformation.size ]
                , Html.p [] [ Html.small [] [ Html.text "Size" ] ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.div [ Attr.class "col-md-5" ]
                [ Html.table [ Attr.class "table table-striped table-bordered" ]
                    [ Html.thead []
                        [ Html.tr []
                            [ Html.th [ Attr.class "text-center" ] [ Html.text "Ability Name" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Score" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Modifier" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "EModji" ]
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
            , Html.div [ Attr.class "col-md-1" ]
                [ Html.b [] [ Html.text "Hit Points" ]
                , Html.input [ Attr.readonly True, Attr.class "form-control", Attr.value <| toString character.combatNumbers.currentHitPoints ] []
                , Html.text "Current"
                , Html.input [ Attr.readonly True, Attr.class "form-control", Attr.value <| toString character.combatNumbers.maxHitPoints ] []
                , Html.text "Max"
                ]
            , Html.div [ Attr.class "col-md-6" ]
                [ Html.h2 [ Attr.class "text-center" ] [ Html.text "Skills" ]
                , Html.table [ Attr.class "table table-striped table-bordered" ]
                    [ Html.thead []
                        [ Html.tr []
                            [ Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Bonus" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Mod" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Ability Name" ]
                            , Html.th [ Attr.class "text-center" ] [ Html.text "Ranks" ]
                            ]
                        ]
                    , Html.tbody [ Attr.class "text-center" ]
                        (List.map
                            (\skill ->
                                Html.tr []
                                    [ Html.td [] [ Html.b [] [ Html.text <| buildSkillName skill ] ]
                                    , Html.td [] [ Html.text (toString skill.total) ]
                                    , Html.td [] [ Html.text (toString skill.abilityMod) ]
                                    , Html.td [] [ Html.text skill.ability ]
                                    , Html.td [] [ Html.text (toString skill.count) ]
                                    ]
                            )
                            character.skills
                        )
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
        , Html.td [] [ Html.text (toString ability.score) ]
        , Html.td [] [ Html.b [] [ Html.text (toString ability.modifier) ] ]
        , Html.td []
            [ Html.text <|
                if ability.modifier >= 0 then
                    String.repeat (ability.modifier) emoji
                else
                    "➖" ++ String.repeat (-ability.modifier) emoji
            ]
        ]

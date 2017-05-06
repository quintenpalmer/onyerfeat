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
        [ Css.width <| Css.pct 100
        , Css.height <| Css.pct 100
        , Css.fontFamilies [ "Inconsolata" ]
        ]


header =
    cssStyle
        [ Css.width <| Css.pct 100
        , Css.height <| Css.px 20
        , Css.padding <| Css.px 20
        , Css.color <| Css.rgb 250 250 250
        , Css.backgroundColor <| Css.rgb 70 70 70
        ]


content =
    cssStyle
        [ Css.textAlign Css.center
        , Css.width <| Css.pct 80
        , Css.height <| Css.pct 100
        , Css.margin Css.auto
        ]


p =
    cssStyle
        [ Css.padding <| Css.px 10
        ]


h1 =
    cssStyle
        [ Css.padding <| Css.px 10
        , Css.fontSize Css.xLarge
        ]


table =
    cssStyle
        [ Css.width (Css.px 350)
        , Css.border (Css.px 2)
        ]


tableData =
    cssStyle
        [ Css.border3 (Css.px 1) Css.solid (Css.rgb 200 200 200)
        , Css.padding (Css.px 3)
        ]


view : Models.Model -> Html.Html Common.Msg
view model =
    div
        [ fullPage
        ]
        [ div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , div [ content ]
            [ case model of
                Models.MCharacter c ->
                    innerPage c

                Models.MError e ->
                    div [ h1 ] [ Html.text e ]

                Models.MNotLoaded ->
                    div [ h1 ] [ Html.text "Loading" ]
            ]
        ]


innerPage : Models.Character -> Html.Html Common.Msg
innerPage character =
    div []
        [ Html.div [ h1 ] [ Html.text "Welcome!" ]
        , Html.div [ p ] [ Html.text <| "Hello, " ++ character.name ++ "! Good to see ya!" ]
        , Html.div []
            [ Html.div [ p ] [ Html.text <| "Alignment: " ++ capitalize character.alignment.order ++ " " ++ capitalize character.alignment.morality ]
            , Html.div [ p ] [ Html.text <| "Player name: " ++ character.playerName ]
            , Html.table [ table ]
                [ Html.tr []
                    [ Html.th [] [ Html.text "Ability Name" ]
                    , Html.th [] [ Html.text "Score" ]
                    , Html.th [] [ Html.text "Modifier" ]
                    , Html.th [] [ Html.text "EModji" ]
                    ]
                , scoreTableRow "STR" character.abilityScores.str "🐂"
                , scoreTableRow "DEX" character.abilityScores.dex "🐆"
                , scoreTableRow "CON" character.abilityScores.con "🐎"
                , scoreTableRow "INT" character.abilityScores.int "\x1F991"
                , scoreTableRow "WIS" character.abilityScores.wis "\x1F989"
                , scoreTableRow "CHA" character.abilityScores.cha "🎭"
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


scoreTableRow : String -> Int -> String -> Html.Html Common.Msg
scoreTableRow name val emoji =
    let
        mod =
            calcAbilityModifier val
    in
        Html.tr []
            [ htmlTdStr name
            , htmlTdStr (toString val)
            , htmlTdStr (toString <| mod)
            , htmlTdStr <|
                if mod >= 0 then
                    String.repeat (mod) emoji
                else
                    "➖" ++ String.repeat (-mod) emoji
            ]


htmlTdStr : String -> Html.Html Common.Msg
htmlTdStr s =
    Html.td [ tableData ]
        [ Html.text s ]


calcAbilityModifier : Int -> Int
calcAbilityModifier i =
    let
        rounded =
            if i % 2 == 0 then
                i
            else if i > 0 then
                i - 1
            else
                i + 1
    in
        (rounded - 10) // 2

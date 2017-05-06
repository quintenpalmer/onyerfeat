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
        [ Css.width <| Css.pct 100
        , Css.padding <| Css.px 20
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
            [ Html.div [ Attr.class "col-md-4" ]
                [ Html.h1 [] [ Html.text "CHARACTER SHEET" ] ]
            , Html.div [ Attr.class "col-md-2" ] []
            , Html.div [ Attr.class "col-md-3" ]
                [ Html.u [] [ Html.text character.playerName ]
                , Html.p [] [ Html.small [] [ Html.text "Player name" ] ]
                ]
            , Html.div [ Attr.class "col-md-3" ]
                [ Html.u [] [ Html.text <| capitalize character.alignment.order ++ " " ++ capitalize character.alignment.morality ]
                , Html.p [] [ Html.small [] [ Html.text "Alignment" ] ]
                ]
            ]
        , Html.div [ Attr.class "row" ]
            [ Html.table [ Attr.class "table table-striped table-bordered" ]
                [ Html.thead []
                    [ Html.tr []
                        [ Html.th [] [ Html.text "Ability Name" ]
                        , Html.th [] [ Html.text "Score" ]
                        , Html.th [] [ Html.text "Modifier" ]
                        , Html.th [] [ Html.text "EModji" ]
                        ]
                    ]
                , Html.tbody []
                    [ scoreTableRow "STR" character.abilityScores.str "🐂"
                    , scoreTableRow "DEX" character.abilityScores.dex "🐆"
                    , scoreTableRow "CON" character.abilityScores.con "🐎"
                    , scoreTableRow "INT" character.abilityScores.int "\x1F991"
                    , scoreTableRow "WIS" character.abilityScores.wis "\x1F989"
                    , scoreTableRow "CHA" character.abilityScores.cha "🎭"
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
    Html.td []
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

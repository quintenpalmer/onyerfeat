module Main exposing (main)

import Html exposing (div)
import Html.Attributes as Attr
import Char
import Css
import Json.Decode as Decode
import Http


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Model
    = MCharacter Character
    | MError String
    | MNotLoaded


type alias Character =
    { id : Int
    , name : String
    , abilityScores : AbilityScoreSet
    , alignment : Alignment
    }


type alias AbilityScoreSet =
    { str : Int
    , dex : Int
    , con : Int
    , int : Int
    , wis : Int
    , cha : Int
    }


type alias Alignment =
    { morality : String
    , order : String
    }


init : ( Model, Cmd Msg )
init =
    ( MNotLoaded
    , getCharacterSheet 1
    )


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error Character)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg character =
    case msg of
        DoLoadSheet ->
            ( character, getCharacterSheet 1 )

        SheetLoaded (Ok newCharacter) ->
            ( MCharacter newCharacter, Cmd.none )

        SheetLoaded (Err _) ->
            ( MError "Error loading sheet", Cmd.none )


getCharacterSheet : Int -> Cmd Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/character?id=" ++ (toString id)
    in
        Http.send SheetLoaded (Http.get url decodeCharacterResp)


decodeCharacterResp : Decode.Decoder Character
decodeCharacterResp =
    Decode.map4 Character
        (Decode.at [ "data", "id" ] Decode.int)
        (Decode.at [ "data", "name" ] Decode.string)
        (Decode.at [ "data", "ability_scores" ] decodeAbilityScores)
        (Decode.at [ "data", "alignment" ] decodeAlignment)


decodeAbilityScores : Decode.Decoder AbilityScoreSet
decodeAbilityScores =
    Decode.map6 AbilityScoreSet
        (Decode.field "str" Decode.int)
        (Decode.field "dex" Decode.int)
        (Decode.field "con" Decode.int)
        (Decode.field "int" Decode.int)
        (Decode.field "wis" Decode.int)
        (Decode.field "cha" Decode.int)


decodeAlignment : Decode.Decoder Alignment
decodeAlignment =
    Decode.map2 Alignment
        (Decode.field "morality" Decode.string)
        (Decode.field "order" Decode.string)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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
                MCharacter c ->
                    innerPage c

                MError e ->
                    div [ h1 ] [ Html.text e ]

                MNotLoaded ->
                    div [ h1 ] [ Html.text "Loading" ]
            ]
        ]


innerPage character =
    div []
        [ Html.div [ h1 ] [ Html.text "Welcome!" ]
        , Html.div [ p ] [ Html.text <| "Hello, " ++ character.name ++ "! Good to see ya!" ]
        , Html.div []
            [ Html.div [ p ] [ Html.text <| "Alignment: " ++ capitalize character.alignment.morality ++ " " ++ capitalize character.alignment.order ]
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


scoreTableRow : String -> Int -> String -> Html.Html Msg
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

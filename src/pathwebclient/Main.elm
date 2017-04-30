module Main exposing (main)

import Html exposing (div)
import Html.Attributes as Attr
import Css
import Json.Decode as Decode
import Http


main =
    Html.program
        { init = init "Stranger"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { id : Int
    , name : String
    , abilityScores : AbilityScoreSet
    }


type alias AbilityScoreSet =
    { str : Int
    , dex : Int
    , con : Int
    , int : Int
    , wis : Int
    , cha : Int
    }


emptyAbilityScoreSet : AbilityScoreSet
emptyAbilityScoreSet =
    AbilityScoreSet 0 0 0 0 0 0


init : String -> ( Model, Cmd Msg )
init name =
    ( Model 0 name emptyAbilityScoreSet
    , getCharacterSheet 1
    )


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoLoadSheet ->
            ( model, getCharacterSheet model.id )

        SheetLoaded (Ok newModel) ->
            ( newModel, Cmd.none )

        SheetLoaded (Err _) ->
            ( Model 0 "ErrorCauser" emptyAbilityScoreSet, Cmd.none )


getCharacterSheet : Int -> Cmd Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/character?id=" ++ (toString id)
    in
        Http.send SheetLoaded (Http.get url decodeCharacterResp)


decodeCharacterResp : Decode.Decoder Model
decodeCharacterResp =
    Decode.map3 Model
        (Decode.at [ "data", "id" ] Decode.int)
        (Decode.at [ "data", "name" ] Decode.string)
        (Decode.at [ "data", "ability_scores" ] decodeAbilityScores)


decodeAbilityScores : Decode.Decoder AbilityScoreSet
decodeAbilityScores =
    Decode.map6 AbilityScoreSet
        (Decode.field "str" Decode.int)
        (Decode.field "dex" Decode.int)
        (Decode.field "con" Decode.int)
        (Decode.field "int" Decode.int)
        (Decode.field "wis" Decode.int)
        (Decode.field "cha" Decode.int)


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
            [ innerPage model ]
        ]


innerPage model =
    div []
        [ Html.div [ h1 ] [ Html.text "Welcome!" ]
        , Html.div [ p ] [ Html.text <| "Hello, " ++ model.name ++ "! Good to see ya!" ]
        , Html.div []
            [ Html.table [ table ]
                [ Html.tr []
                    [ Html.th [] [ Html.text "Ability Name" ]
                    , Html.th [] [ Html.text "Score" ]
                    , Html.th [] [ Html.text "Modifier" ]
                    , Html.th [] [ Html.text "EModji" ]
                    ]
                , scoreTableRow "STR" model.abilityScores.str "🐂"
                , scoreTableRow "DEX" model.abilityScores.dex "🐆"
                , scoreTableRow "CON" model.abilityScores.con "🐎"
                , scoreTableRow "INT" model.abilityScores.int "\x1F991"
                , scoreTableRow "WIS" model.abilityScores.wis "\x1F989"
                , scoreTableRow "CHA" model.abilityScores.cha "🎭"
                ]
            ]
        ]


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
            , htmlTdStr
                <| if mod >= 0 then
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

module Main exposing (main)

import Html
import Json.Decode as Decode
import Http
import Models
import View


main =
    Html.program
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Models.Model, Cmd Msg )
init =
    ( Models.MNotLoaded
    , getCharacterSheet 1
    )


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error Models.Character)


update : Msg -> Models.Model -> ( Models.Model, Cmd Msg )
update msg character =
    case msg of
        DoLoadSheet ->
            ( character, getCharacterSheet 1 )

        SheetLoaded (Ok newCharacter) ->
            ( Models.MCharacter newCharacter, Cmd.none )

        SheetLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )


getCharacterSheet : Int -> Cmd Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/character?id=" ++ (toString id)
    in
        Http.send SheetLoaded (Http.get url decodeCharacterResp)


decodeCharacterResp : Decode.Decoder Models.Character
decodeCharacterResp =
    Decode.field "data" decodeCharacter


decodeCharacter : Decode.Decoder Models.Character
decodeCharacter =
    Decode.map5 Models.Character
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "player_name" Decode.string)
        (Decode.field "ability_scores" decodeAbilityScores)
        (Decode.field "alignment" decodeAlignment)


decodeAbilityScores : Decode.Decoder Models.AbilityScoreSet
decodeAbilityScores =
    Decode.map6 Models.AbilityScoreSet
        (Decode.field "str" Decode.int)
        (Decode.field "dex" Decode.int)
        (Decode.field "con" Decode.int)
        (Decode.field "int" Decode.int)
        (Decode.field "wis" Decode.int)
        (Decode.field "cha" Decode.int)


decodeAlignment : Decode.Decoder Models.Alignment
decodeAlignment =
    Decode.map2 Models.Alignment
        (Decode.field "morality" Decode.string)
        (Decode.field "order" Decode.string)


subscriptions : Models.Model -> Sub Msg
subscriptions model =
    Sub.none

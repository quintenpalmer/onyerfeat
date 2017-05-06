module Main exposing (main)

import Html
import Http
import Models
import View
import Decoding


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
        Http.send SheetLoaded (Http.get url Decoding.decodeCharacterResp)


subscriptions : Models.Model -> Sub Msg
subscriptions model =
    Sub.none

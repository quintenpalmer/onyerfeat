module Control exposing (init, update, subscriptions)

import Http
import Models
import Common
import Decoding


init : ( Models.Model, Cmd Common.Msg )
init =
    ( Models.MNotLoaded
    , getCharacterSheet 1
    )


update : Common.Msg -> Models.Model -> ( Models.Model, Cmd Common.Msg )
update msg character =
    case msg of
        Common.LoadCharacter id ->
            ( character, getCharacterSheet id )

        Common.LoadShields ->
            ( character, getShields )

        Common.ShieldsLoaded (Ok newShields) ->
            ( Models.MShields newShields, Cmd.none )

        Common.ShieldsLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )

        Common.CharacterLoaded (Ok newCharacter) ->
            ( Models.MCharacter newCharacter, Cmd.none )

        Common.CharacterLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )


getCharacterSheet : Int -> Cmd Common.Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/api/characters?id=" ++ (toString id)
    in
        Http.send Common.CharacterLoaded (Http.get url Decoding.decodeCharacterResp)


getShields : Cmd Common.Msg
getShields =
    let
        url =
            "http://localhost:3000/api/shields"
    in
        Http.send Common.ShieldsLoaded (Http.get url Decoding.decodeShields)


subscriptions : Models.Model -> Sub Common.Msg
subscriptions model =
    Sub.none

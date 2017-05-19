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
        Common.DoLoadSheet ->
            ( character, getCharacterSheet 1 )

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


subscriptions : Models.Model -> Sub Common.Msg
subscriptions model =
    Sub.none

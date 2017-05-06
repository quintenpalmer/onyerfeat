module Main exposing (main)

import Html
import Http
import Common
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

        Common.SheetLoaded (Ok newCharacter) ->
            ( Models.MCharacter newCharacter, Cmd.none )

        Common.SheetLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )


getCharacterSheet : Int -> Cmd Common.Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/character?id=" ++ (toString id)
    in
        Http.send Common.SheetLoaded (Http.get url Decoding.decodeCharacterResp)


subscriptions : Models.Model -> Sub Common.Msg
subscriptions model =
    Sub.none

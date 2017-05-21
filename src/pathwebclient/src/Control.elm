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

        Common.LoadWeapons ->
            ( character, getWeapons )

        Common.LoadShields ->
            ( character, getShields )

        Common.LoadArmorPieces ->
            ( character, getArmorPieces )

        Common.DiceTab ->
            ( Models.MDiceTab Nothing, Cmd.none )

        Common.LoadDie die ->
            ( Models.MDiceTab Nothing, getDiceRoll die )

        Common.DiceLoaded (Ok dieRoll) ->
            ( Models.MDiceTab <| Just dieRoll, Cmd.none )

        Common.DiceLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )

        Common.WeaponsLoaded (Ok newWeapons) ->
            ( Models.MWeapons newWeapons, Cmd.none )

        Common.WeaponsLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )

        Common.ArmorPiecesLoaded (Ok newArmorPieces) ->
            ( Models.MArmorPieces newArmorPieces, Cmd.none )

        Common.ArmorPiecesLoaded (Err e) ->
            ( Models.MError <| "Error loading sheet: " ++ toString e, Cmd.none )

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


getWeapons : Cmd Common.Msg
getWeapons =
    let
        url =
            "http://localhost:3000/api/weapons"
    in
        Http.send Common.WeaponsLoaded (Http.get url Decoding.decodeWeapons)


getShields : Cmd Common.Msg
getShields =
    let
        url =
            "http://localhost:3000/api/shields"
    in
        Http.send Common.ShieldsLoaded (Http.get url Decoding.decodeShields)


getArmorPieces : Cmd Common.Msg
getArmorPieces =
    let
        url =
            "http://localhost:3000/api/armor_pieces"
    in
        Http.send Common.ArmorPiecesLoaded (Http.get url Decoding.decodeArmorPieces)


getDiceRoll : Int -> Cmd Common.Msg
getDiceRoll die =
    let
        url =
            "http://localhost:3000/api/roll?die=" ++ (toString die)
    in
        Http.send Common.DiceLoaded (Http.get url Decoding.decodeDie)


subscriptions : Models.Model -> Sub Common.Msg
subscriptions model =
    Sub.none

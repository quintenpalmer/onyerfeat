module Decoding exposing (decodeCharacterResp)

import Json.Decode as Decode
import Models


decodeCharacterResp : Decode.Decoder Models.Character
decodeCharacterResp =
    Decode.field "data" decodeCharacter


decodeCharacter : Decode.Decoder Models.Character
decodeCharacter =
    Decode.map6 Models.Character
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "player_name" Decode.string)
        (Decode.field "ability_scores" decodeAbilityScores)
        (Decode.field "alignment" decodeAlignment)
        (Decode.field "meta_information" decodeMetaInformation)


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


decodeMetaInformation : Decode.Decoder Models.MetaInformation
decodeMetaInformation =
    Decode.map3 Models.MetaInformation
        (Decode.field "class" Decode.string)
        (Decode.field "race" Decode.string)
        (Decode.field "deity" <| Decode.nullable Decode.string)

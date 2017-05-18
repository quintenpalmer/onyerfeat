module Decoding exposing (decodeCharacterResp, decodeArmorPieces)

import Json.Decode as Decode
import Models


decodeCharacterResp : Decode.Decoder Models.Character
decodeCharacterResp =
    Decode.field "data" decodeCharacter


decodeCharacter : Decode.Decoder Models.Character
decodeCharacter =
    Decode.map5 Models.Character
        (Decode.field "id" Decode.int)
        (Decode.field "ability_score_info" decodeAbilityScores)
        (Decode.field "meta_information" decodeMetaInformation)
        (Decode.field "combat_numbers" decodeCombatNumbers)
        (Decode.field "skills" decodeSkills)


decodeSkills : Decode.Decoder (List Models.Skill)
decodeSkills =
    Decode.list decodeSkill


decodeSkill : Decode.Decoder Models.Skill
decodeSkill =
    Decode.map8 Models.Skill
        (Decode.field "name" Decode.string)
        (Decode.field "sub_name" <| Decode.nullable Decode.string)
        (Decode.field "total" Decode.int)
        (Decode.field "ability" Decode.string)
        (Decode.field "ability_mod" Decode.int)
        (Decode.field "is_class_skill" Decode.bool)
        (Decode.field "class_mod" Decode.int)
        (Decode.field "count" Decode.int)


decodeCombatNumbers : Decode.Decoder Models.CombatNumbers
decodeCombatNumbers =
    Decode.map3 Models.CombatNumbers
        (Decode.field "max_hit_points" Decode.int)
        (Decode.field "current_hit_points" Decode.int)
        (Decode.field "nonlethal_damage" Decode.int)


decodeAbilityScores : Decode.Decoder Models.AbilityScoreSet
decodeAbilityScores =
    Decode.map6 Models.AbilityScoreSet
        (Decode.field "str" decodeAbility)
        (Decode.field "dex" decodeAbility)
        (Decode.field "con" decodeAbility)
        (Decode.field "int" decodeAbility)
        (Decode.field "wis" decodeAbility)
        (Decode.field "cha" decodeAbility)


decodeAbility : Decode.Decoder Models.Ability
decodeAbility =
    Decode.map2 Models.Ability
        (Decode.field "score" Decode.int)
        (Decode.field "modifier" Decode.int)


decodeAlignment : Decode.Decoder Models.Alignment
decodeAlignment =
    Decode.map2 Models.Alignment
        (Decode.field "morality" Decode.string)
        (Decode.field "order" Decode.string)


decodeMetaInformation : Decode.Decoder Models.MetaInformation
decodeMetaInformation =
    Decode.map8 Models.MetaInformation
        (Decode.field "name" Decode.string)
        (Decode.field "player_name" Decode.string)
        (Decode.field "alignment" decodeAlignment)
        (Decode.field "class" Decode.string)
        (Decode.field "race" Decode.string)
        (Decode.field "deity" <| Decode.nullable Decode.string)
        (Decode.field "age" Decode.int)
        (Decode.field "size" Decode.string |> Decode.andThen decodeSize)


decodeSize : String -> Decode.Decoder Models.Size
decodeSize s =
    case s of
        "colossal" ->
            Decode.succeed Models.Colossal

        "gargantuan" ->
            Decode.succeed Models.Gargantuan

        "huge" ->
            Decode.succeed Models.Huge

        "large" ->
            Decode.succeed Models.Large

        "medium" ->
            Decode.succeed Models.Medium

        "small" ->
            Decode.succeed Models.Small

        "tiny" ->
            Decode.succeed Models.Tiny

        "diminutive" ->
            Decode.succeed Models.Diminutive

        "fine" ->
            Decode.succeed Models.Fine

        _ ->
            Decode.fail "could not parse size"


decodeArmorPieces : Decode.Decoder (List Models.ArmorPiece)
decodeArmorPieces =
    Decode.field "data" (Decode.list decodeArmorPiece)


decodeArmorPiece : Decode.Decoder Models.ArmorPiece
decodeArmorPiece =
    Decode.map8 Models.ArmorPiece
        (Decode.field "armor_class" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "armor_bonus" Decode.int)
        (Decode.field "max_dex_bonus" Decode.int)
        (Decode.field "armor_check_penalty" Decode.int)
        --(Decode.field "arcane_spell_failure_chance" Decode.int)
        (Decode.field "fast_speed" Decode.int)
        (Decode.field "slow_speed" Decode.int)
        (Decode.field "medium_weight" Decode.int)

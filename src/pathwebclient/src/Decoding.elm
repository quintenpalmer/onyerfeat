module Decoding
    exposing
        ( decodeCharacterResp
        , decodeArmorPieces
        , decodeShields
        , decodeWeapons
        , decodeDie
        )

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Models


decodeCharacterResp : Decode.Decoder Models.Character
decodeCharacterResp =
    Decode.field "data" decodeCharacter


decodeCharacter : Decode.Decoder Models.Character
decodeCharacter =
    Pipeline.decode Models.Character
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "level" Decode.int
        |> Pipeline.required "ability_score_info" decodeAbilityScores
        |> Pipeline.required "meta_information" decodeMetaInformation
        |> Pipeline.required "combat_numbers" decodeCombatNumbers
        |> Pipeline.required "armor_piece" decodeArmorPieceInstance
        |> Pipeline.required "shield" (Decode.nullable decodePersonalShield)
        |> Pipeline.required "full_weapons" (Decode.list decodeWeaponInstance)
        |> Pipeline.required "combat_weapon_stats" (Decode.list decodeCombatWeaponStats)
        |> Pipeline.required "skills" decodeSkills
        |> Pipeline.required "languages" (Decode.list decodeLanguage)
        |> Pipeline.required "items" (Decode.list decodeItem)


decodeSkills : Decode.Decoder (List Models.Skill)
decodeSkills =
    Decode.list decodeSkill


decodeSkill : Decode.Decoder Models.Skill
decodeSkill =
    Pipeline.decode Models.Skill
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "sub_name" (Decode.nullable Decode.string)
        |> Pipeline.required "total" Decode.int
        |> Pipeline.required "ability" Decode.string
        |> Pipeline.required "ability_mod" Decode.int
        |> Pipeline.required "is_class_skill" Decode.bool
        |> Pipeline.required "class_mod" Decode.int
        |> Pipeline.required "count" Decode.int
        |> Pipeline.required "armor_check_penalty" (Decode.nullable Decode.int)


decodeCombatNumbers : Decode.Decoder Models.CombatNumbers
decodeCombatNumbers =
    Pipeline.decode Models.CombatNumbers
        |> Pipeline.required "max_hit_points" Decode.int
        |> Pipeline.required "current_hit_points" Decode.int
        |> Pipeline.required "nonlethal_damage" Decode.int
        |> Pipeline.required "armor_class" decodeArmorClass
        |> Pipeline.required "base_attack_bonus" Decode.int
        |> Pipeline.required "saving_throws" decodeSavingThrows
        |> Pipeline.required "combat_maneuvers" decodeCombatManeuvers


decodeCombatManeuvers : Decode.Decoder Models.CombatManeuvers
decodeCombatManeuvers =
    Pipeline.decode Models.CombatManeuvers
        |> Pipeline.required "bonus" decodeCombatManeuverBonus
        |> Pipeline.required "defense" decodeCombatManeuverDefense


decodeCombatManeuverBonus : Decode.Decoder Models.CombatManeuverBonus
decodeCombatManeuverBonus =
    Pipeline.decode Models.CombatManeuverBonus
        |> Pipeline.required "total" Decode.int
        |> Pipeline.required "str" Decode.int
        |> Pipeline.required "base_attack_bonus" Decode.int
        |> Pipeline.required "size_mod" Decode.int


decodeCombatManeuverDefense : Decode.Decoder Models.CombatManeuverDefense
decodeCombatManeuverDefense =
    Pipeline.decode Models.CombatManeuverDefense
        |> Pipeline.required "total" Decode.int
        |> Pipeline.required "base" Decode.int
        |> Pipeline.required "str" Decode.int
        |> Pipeline.required "dex" Decode.int
        |> Pipeline.required "base_attack_bonus" Decode.int
        |> Pipeline.required "size_mod" Decode.int


decodeSavingThrows : Decode.Decoder Models.SavingThrows
decodeSavingThrows =
    Pipeline.decode Models.SavingThrows
        |> Pipeline.required "fortitude" decodeSavingThrow
        |> Pipeline.required "reflex" decodeSavingThrow
        |> Pipeline.required "will" decodeSavingThrow


decodeSavingThrow : Decode.Decoder Models.SavingThrow
decodeSavingThrow =
    Pipeline.decode Models.SavingThrow
        |> Pipeline.required "total" Decode.int
        |> Pipeline.required "base" Decode.int
        |> Pipeline.required "ability_mod" Decode.int
        |> Pipeline.required "other" Decode.int
        |> Pipeline.required "ability_name" Decode.string


decodeArmorClass : Decode.Decoder Models.ArmorClass
decodeArmorClass =
    Pipeline.decode Models.ArmorClass
        |> Pipeline.required "total" Decode.int
        |> Pipeline.required "base" Decode.int
        |> Pipeline.required "dex" Decode.int
        |> Pipeline.required "armor_ac" Decode.int
        |> Pipeline.required "shield_ac" Decode.int
        |> Pipeline.required "misc" Decode.int
        |> Pipeline.required "size_mod" Decode.int


decodeAbilityScores : Decode.Decoder Models.AbilityScoreSet
decodeAbilityScores =
    Pipeline.decode Models.AbilityScoreSet
        |> Pipeline.required "str" decodeAbility
        |> Pipeline.required "dex" decodeAbility
        |> Pipeline.required "con" decodeAbility
        |> Pipeline.required "int" decodeAbility
        |> Pipeline.required "wis" decodeAbility
        |> Pipeline.required "cha" decodeAbility


decodeAbility : Decode.Decoder Models.Ability
decodeAbility =
    Pipeline.decode Models.Ability
        |> Pipeline.required "score" Decode.int
        |> Pipeline.required "modifier" Decode.int


decodeAlignment : Decode.Decoder Models.Alignment
decodeAlignment =
    Pipeline.decode Models.Alignment
        |> Pipeline.required "morality" Decode.string
        |> Pipeline.required "order" Decode.string


decodeMetaInformation : Decode.Decoder Models.MetaInformation
decodeMetaInformation =
    Pipeline.decode Models.MetaInformation
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "player_name" Decode.string
        |> Pipeline.required "alignment" decodeAlignment
        |> Pipeline.required "class" Decode.string
        |> Pipeline.required "race" Decode.string
        |> Pipeline.required "deity" (Decode.nullable Decode.string)
        |> Pipeline.required "age" Decode.int
        |> Pipeline.required "size" (Decode.string |> Decode.andThen decodeSize)


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


decodeLanguage : Decode.Decoder Models.Language
decodeLanguage =
    Pipeline.decode Models.Language
        |> Pipeline.required "name" Decode.string


decodeArmorPieces : Decode.Decoder (List Models.ArmorPiece)
decodeArmorPieces =
    Decode.field "data" (Decode.list decodeArmorPiece)


decodeArmorPiece : Decode.Decoder Models.ArmorPiece
decodeArmorPiece =
    Pipeline.decode Models.ArmorPiece
        |> Pipeline.required "armor_class" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "armor_bonus" Decode.int
        |> Pipeline.required "max_dex_bonus" Decode.int
        |> Pipeline.required "armor_check_penalty" Decode.int
        |> Pipeline.required "arcane_spell_failure_chance" Decode.int
        |> Pipeline.required "fast_speed" Decode.int
        |> Pipeline.required "slow_speed" Decode.int
        |> Pipeline.required "medium_weight" Decode.int


decodeArmorPieceInstance : Decode.Decoder Models.ArmorPieceInstance
decodeArmorPieceInstance =
    Pipeline.decode Models.ArmorPieceInstance
        |> Pipeline.required "armor_class" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "armor_bonus" Decode.int
        |> Pipeline.required "max_dex_bonus" Decode.int
        |> Pipeline.required "armor_check_penalty" Decode.int
        |> Pipeline.required "arcane_spell_failure_chance" Decode.int
        |> Pipeline.required "fast_speed" Decode.int
        |> Pipeline.required "slow_speed" Decode.int
        |> Pipeline.required "medium_weight" Decode.int
        |> Pipeline.required "is_masterwork" Decode.bool
        |> Pipeline.required "special" (Decode.nullable Decode.string)


decodeShields : Decode.Decoder (List Models.Shield)
decodeShields =
    Decode.field "data" (Decode.list decodeShield)


decodeShield : Decode.Decoder Models.Shield
decodeShield =
    Pipeline.decode Models.Shield
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "ac_bonus" Decode.int
        |> Pipeline.required "max_dex" (Decode.nullable Decode.int)
        |> Pipeline.required "skill_penalty" Decode.int
        |> Pipeline.required "arcane_spell_failure_chance" Decode.int
        |> Pipeline.required "weight" Decode.int
        |> Pipeline.required "size_style" (Decode.nullable Decode.string)


decodePersonalShield : Decode.Decoder Models.PersonalShield
decodePersonalShield =
    Pipeline.decode Models.PersonalShield
        |> Pipeline.required "shield" decodeShield
        |> Pipeline.required "has_spikes" Decode.bool
        |> Pipeline.required "is_masterwork" Decode.bool
        |> Pipeline.required "special" (Decode.nullable Decode.string)


decodeWeapons : Decode.Decoder (List Models.Weapon)
decodeWeapons =
    Decode.field "data" (Decode.list decodeWeapon)


decodeWeaponInstance : Decode.Decoder Models.WeaponInstance
decodeWeaponInstance =
    Pipeline.decode Models.WeaponInstance
        |> Pipeline.required "weapon" decodeWeapon
        |> Pipeline.required "is_masterwork" Decode.bool
        |> Pipeline.required "special" (Decode.nullable Decode.string)


decodeWeapon : Decode.Decoder Models.Weapon
decodeWeapon =
    Pipeline.decode Models.Weapon
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "training_type" Decode.string
        |> Pipeline.required "size_style" Decode.string
        |> Pipeline.required "cost" Decode.int
        |> Pipeline.required "small_damage" decodeDiceDamage
        |> Pipeline.required "medium_damage" decodeDiceDamage
        |> Pipeline.required "critical" decodeCriticalDamage
        |> Pipeline.required "range" Decode.int
        |> Pipeline.required "weight" Decode.int
        |> Pipeline.required "damage_type" decodePhysicalDamageType


decodeCombatWeaponStats : Decode.Decoder Models.CombatWeaponStats
decodeCombatWeaponStats =
    Pipeline.decode Models.CombatWeaponStats
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "training_type" Decode.string
        |> Pipeline.required "size_style" Decode.string
        |> Pipeline.required "dice_damage" decodeDiceDamage
        |> Pipeline.required "critical" decodeCriticalDamage
        |> Pipeline.required "range" Decode.int
        |> Pipeline.required "damage_type" decodePhysicalDamageType
        |> Pipeline.required "attack_bonus" Decode.int
        |> Pipeline.required "damage" Decode.int


decodeItem : Decode.Decoder Models.CreatureItem
decodeItem =
    Pipeline.decode Models.CreatureItem
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "description" Decode.string
        |> Pipeline.required "count" Decode.int


decodePhysicalDamageType : Decode.Decoder Models.PhysicalDamageType
decodePhysicalDamageType =
    Pipeline.decode Models.PhysicalDamageType
        |> Pipeline.required "bludgeoning" Decode.bool
        |> Pipeline.required "piercing" Decode.bool
        |> Pipeline.required "slashing" Decode.bool
        |> Pipeline.required "and_together" Decode.bool


decodeCriticalDamage : Decode.Decoder Models.CriticalDamage
decodeCriticalDamage =
    Pipeline.decode Models.CriticalDamage
        |> Pipeline.required "required_roll" Decode.int
        |> Pipeline.required "multiplier" Decode.int


decodeDiceDamage : Decode.Decoder Models.DiceDamage
decodeDiceDamage =
    Pipeline.decode Models.DiceDamage
        |> Pipeline.required "num_dice" Decode.int
        |> Pipeline.required "die_size" Decode.int


decodeDie : Decode.Decoder Int
decodeDie =
    Decode.field "data" Decode.int

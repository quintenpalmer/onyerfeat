module Models
    exposing
        ( Model(..)
        , Character
        , AbilityScoreSet
        , Ability
        , Alignment
        , MetaInformation
        , Size(..)
        , CombatNumbers
        , Skill
        , ArmorPiece
        , Shield
        , ArmorClass
        )


type Model
    = MCharacter Character
    | MShields (List Shield)
    | MArmorPieces (List ArmorPiece)
    | MError String
    | MNotLoaded


type alias Character =
    { id : Int
    , abilityScores : AbilityScoreSet
    , metaInformation : MetaInformation
    , combatNumbers : CombatNumbers
    , armorPiece : ArmorPiece
    , shield : Maybe Shield
    , skills : List Skill
    }


type alias CombatNumbers =
    { maxHitPoints : Int
    , currentHitPoints : Int
    , nonlethalDamage : Int
    , armorClass : ArmorClass
    , baseAttackBonus : Int
    }


type alias ArmorClass =
    { total : Int
    , base : Int
    , dex : Int
    , armorAc : Int
    , shieldAc : Int
    , sizeMod : Int
    }


type alias AbilityScoreSet =
    { str : Ability
    , dex : Ability
    , con : Ability
    , int : Ability
    , wis : Ability
    , cha : Ability
    }


type alias Ability =
    { score : Int
    , modifier : Int
    }


type alias Alignment =
    { morality : String
    , order : String
    }


type Size
    = Colossal
    | Gargantuan
    | Huge
    | Large
    | Medium
    | Small
    | Tiny
    | Diminutive
    | Fine


type alias MetaInformation =
    { name : String
    , playerName : String
    , alignment : Alignment
    , class : String
    , race : String
    , deity : Maybe String
    , age : Int
    , size : Size
    }


type alias Skill =
    { name : String
    , sub_name : Maybe String
    , total : Int
    , ability : String
    , abilityMod : Int
    , isClassSkill : Bool
    , classMod : Int
    , count : Int
    , armorCheckPenalty : Maybe Int
    }


type alias ArmorPiece =
    { armorClass : String
    , name : String
    , armorBonus : Int
    , maxDexBonus : Int
    , armorCheckPenalty : Int
    , arcaneSpellFailureChance : Int
    , fastSpeed : Int
    , slowSpeed : Int
    , mediumWeight : Int
    }


type alias Shield =
    { name : String
    , acBonus : Int
    , maxDex : Maybe Int
    , skillPenalty : Int
    , arcaneSpellFailureChance : Int
    , weight : Int
    }

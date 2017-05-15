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
        )


type Model
    = MCharacter Character
    | MError String
    | MNotLoaded


type alias Character =
    { id : Int
    , name : String
    , playerName : String
    , abilityScores : AbilityScoreSet
    , alignment : Alignment
    , metaInformation : MetaInformation
    , combatNumbers : CombatNumbers
    , skills : List Skill
    }


type alias CombatNumbers =
    { maxHitPoints : Int
    , currentHitPoints : Int
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
    { class : String
    , race : String
    , deity : Maybe String
    , age : Int
    , size : Size
    }


type alias Skill =
    { name : String
    , total : Int
    , ability : String
    , abilityMod : Int
    , count : Int
    }

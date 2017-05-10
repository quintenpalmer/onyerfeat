module Models exposing (Model(..), Character, AbilityScoreSet, Alignment, MetaInformation, Size(..), CombatNumbers)


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
    }


type alias CombatNumbers =
    { maxHitPoints : Int
    , currentHitPoints : Int
    }


type alias AbilityScoreSet =
    { str : Int
    , dex : Int
    , con : Int
    , int : Int
    , wis : Int
    , cha : Int
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

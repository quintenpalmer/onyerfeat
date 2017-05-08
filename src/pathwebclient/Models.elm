module Models exposing (Model(..), Character, AbilityScoreSet, Alignment, MetaInformation)


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


type alias MetaInformation =
    { class : String
    }

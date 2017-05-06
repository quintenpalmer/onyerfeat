module Models exposing (Model(..), Character, AbilityScoreSet, Alignment)


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

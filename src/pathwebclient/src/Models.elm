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
        , PersonalShield
        , Weapon
        , CombatWeaponStats
        , ArmorClass
        , SavingThrows
        , SavingThrow
        , CombatManeuvers
        , CombatManeuverBonus
        , CombatManeuverDefense
        , DiceDamage
        , CriticalDamage
        , PhysicalDamageType
        , CreatureItem
        )


type Model
    = MCharacter Character
    | MWeapons (List Weapon)
    | MShields (List Shield)
    | MArmorPieces (List ArmorPiece)
    | MDiceTab (Maybe Int)
    | MError String
    | MNotLoaded


type alias Character =
    { id : Int
    , level : Int
    , abilityScores : AbilityScoreSet
    , metaInformation : MetaInformation
    , combatNumbers : CombatNumbers
    , armorPiece : ArmorPiece
    , shield : Maybe PersonalShield
    , fullWeapons : List Weapon
    , combatWeaponStats : List CombatWeaponStats
    , skills : List Skill
    , items : List CreatureItem
    }


type alias CombatNumbers =
    { maxHitPoints : Int
    , currentHitPoints : Int
    , nonlethalDamage : Int
    , armorClass : ArmorClass
    , baseAttackBonus : Int
    , savingThrows : SavingThrows
    , combatManeuvers : CombatManeuvers
    }


type alias CombatManeuvers =
    { bonus : CombatManeuverBonus
    , defense : CombatManeuverDefense
    }


type alias CombatManeuverBonus =
    { total : Int
    , str : Int
    , baseAttackBonus : Int
    , sizeMod : Int
    }


type alias CombatManeuverDefense =
    { total : Int
    , base : Int
    , str : Int
    , dex : Int
    , baseAttackBonus : Int
    , sizeMod : Int
    }


type alias SavingThrows =
    { fortitude : SavingThrow
    , reflex : SavingThrow
    , will : SavingThrow
    }


type alias SavingThrow =
    { total : Int
    , base : Int
    , abilityMod : Int
    , other : Int
    , abilityName : String
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


type alias PersonalShield =
    { shield : Shield
    , hasSpikes : Bool
    }


type alias Shield =
    { name : String
    , acBonus : Int
    , maxDex : Maybe Int
    , skillPenalty : Int
    , arcaneSpellFailureChance : Int
    , weight : Int
    , sizeStyle : Maybe String
    }


type alias Weapon =
    { name : String
    , trainingType : String
    , sizeStyle : String
    , cost : Int
    , smallDamage : DiceDamage
    , mediumDamage : DiceDamage
    , critical : CriticalDamage
    , range : Int
    , weight : Int
    , damageType : PhysicalDamageType
    }


type alias CombatWeaponStats =
    { name : String
    , trainingType : String
    , sizeStyle : String
    , diceDamage : DiceDamage
    , critical : CriticalDamage
    , range : Int
    , damageType : PhysicalDamageType
    , attackBonus : Int
    , damage : Int
    }


type alias CreatureItem =
    { id : Int
    , name : String
    , description : String
    , count : Int
    }


type alias DiceDamage =
    { numDice : Int
    , dieSize : Int
    }


type alias CriticalDamage =
    { requiredRoll : Int
    , multiplier : Int
    }


type alias PhysicalDamageType =
    { bludgeoning : Bool
    , piercing : Bool
    , slashing : Bool
    , andTogether : Bool
    }

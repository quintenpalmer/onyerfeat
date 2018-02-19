module Common exposing (Msg(..), weaponSort)

import Http
import Models


type Msg
    = LoadCharacter Int
    | LoadShields
    | LoadArmorPieces
    | LoadWeapons
    | DiceTab
    | LoadDie Int
    | CharacterLoaded (Result Http.Error Models.Character)
    | WeaponsLoaded (Result Http.Error (List Models.Weapon))
    | ShieldsLoaded (Result Http.Error (List Models.Shield))
    | ArmorPiecesLoaded (Result Http.Error (List Models.ArmorPiece))
    | DiceLoaded (Result Http.Error Int)


weaponSort :
    List
        { a
            | name : comparable
            , sizeStyle : comparable1
            , trainingType : comparable2
        }
    ->
        List
            { a
                | name : comparable
                , sizeStyle : comparable1
                , trainingType : comparable2
            }
weaponSort weapons =
    (List.sortBy .trainingType (List.sortBy .sizeStyle (List.sortBy .name weapons)))

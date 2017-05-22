module Common exposing (Msg(..))

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

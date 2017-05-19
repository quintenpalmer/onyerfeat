module Common exposing (Msg(..))

import Http
import Models


type Msg
    = LoadCharacter Int
    | LoadShields
    | LoadArmorPieces
    | CharacterLoaded (Result Http.Error Models.Character)
    | ShieldsLoaded (Result Http.Error (List Models.Shield))
    | ArmorPiecesLoaded (Result Http.Error (List Models.ArmorPiece))

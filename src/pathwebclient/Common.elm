module Common exposing (Msg(..))

import Http
import Models


type Msg
    = DoLoadSheet
    | CharacterLoaded (Result Http.Error Models.Character)

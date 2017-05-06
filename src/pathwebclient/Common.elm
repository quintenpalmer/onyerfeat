module Common exposing (Msg(..))

import Http
import Models


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error Models.Character)

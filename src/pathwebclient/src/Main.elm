module Main exposing (main)

import Html
import Common
import Control
import Models
import View.Body


main : Program Never Models.Model Common.Msg
main =
    Html.program
        { init = Control.init
        , view = View.Body.view
        , update = Control.update
        , subscriptions = Control.subscriptions
        }

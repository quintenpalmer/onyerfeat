module Main exposing (main)

import Html
import Control
import View.Body


main =
    Html.program
        { init = Control.init
        , view = View.Body.view
        , update = Control.update
        , subscriptions = Control.subscriptions
        }

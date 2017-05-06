module Main exposing (main)

import Html
import Control
import View


main =
    Html.program
        { init = Control.init
        , view = View.view
        , update = Control.update
        , subscriptions = Control.subscriptions
        }

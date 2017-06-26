module View.Formatting
    exposing
        ( capitalize
        )

import Char


capitalize : String -> String
capitalize string =
    case String.uncons string of
        Nothing ->
            ""

        Just ( head, tail ) ->
            String.cons (Char.toUpper head) tail

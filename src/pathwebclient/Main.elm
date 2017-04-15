module Main exposing (main)

import Html exposing (div)
import Html.Attributes as Attr
import Css


cssStyle =
    Css.asPairs >> Attr.style


fullPage =
    cssStyle
        [ Css.width <| Css.pct 100
        , Css.height <| Css.pct 100
        , Css.fontFamilies [ "Inconsolata" ]
        ]


header =
    cssStyle
        [ Css.width <| Css.pct 100
        , Css.height <| Css.px 20
        , Css.padding <| Css.px 20
        , Css.color <| Css.rgb 250 250 250
        , Css.backgroundColor <| Css.rgb 70 70 70
        ]


content =
    cssStyle
        [ Css.textAlign Css.center
        , Css.width <| Css.pct 80
        , Css.height <| Css.pct 100
        , Css.margin Css.auto
        ]


p =
    cssStyle
        [ Css.padding <| Css.px 10
        ]


h1 =
    cssStyle
        [ Css.padding <| Css.px 10
        , Css.fontSize Css.xLarge
        ]


main =
    div
        [ fullPage
        ]
        [ div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , div [ content ]
            [ innerPage ]
        ]


innerPage =
    div []
        [ Html.div [ h1 ] [ Html.text "Welcome!" ]
        , Html.div [ p ] [ Html.text "Hello! I'm sorry, I don't know your name yet." ]
        ]

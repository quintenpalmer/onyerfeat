module Main exposing (main)

import Html exposing (div)
import Html.Attributes as Attr
import Css

import Json.Decode as Decode

import Http


main =
    Html.program
        { init = init "Traveler"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { name : String
    }


init : String -> ( Model, Cmd Msg )
init name =
    ( Model name
    , getCharacterSheet name
    )


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoLoadSheet ->
            ( model, getCharacterSheet model.name )

        SheetLoaded (Ok name) ->
            ( Model name, Cmd.none )

        SheetLoaded (Err _) ->
            ( model, Cmd.none )


getCharacterSheet : String -> Cmd Msg
getCharacterSheet name =
    let
        url =
            "http://localhost:3000/?name=" ++ name
    in
        Http.send SheetLoaded (Http.get url decodeCharacterResp)


decodeCharacterResp : Decode.Decoder String
decodeCharacterResp =
    Decode.at [ "data", "name" ] Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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


view model =
    div
        [ fullPage
        ]
        [ div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , div [ content ]
            [ innerPage model ]
        ]


innerPage model =
    div []
        [ Html.div [ h1 ] [ Html.text "Welcome!" ]
        , Html.div [ p ] [ Html.text <| "Hello, " ++ model.name ++ "! Good to see ya!" ]
        ]

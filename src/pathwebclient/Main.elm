module Main exposing (main)

import Html exposing (div)
import Html.Attributes as Attr
import Css
import Json.Decode as Decode
import Http


main =
    Html.program
        { init = init "Stranger"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { id : Int
    , name : String
    }


init : String -> ( Model, Cmd Msg )
init name =
    ( Model 0 name
    , getCharacterSheet 1
    )


type Msg
    = DoLoadSheet
    | SheetLoaded (Result Http.Error Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoLoadSheet ->
            ( model, getCharacterSheet model.id )

        SheetLoaded (Ok newModel) ->
            ( newModel, Cmd.none )

        SheetLoaded (Err _) ->
            ( Model 0 "ErrorCauser", Cmd.none )


getCharacterSheet : Int -> Cmd Msg
getCharacterSheet id =
    let
        url =
            "http://localhost:3000/character?id=" ++ (toString id)
    in
        Http.send SheetLoaded (Http.get url decodeCharacterResp)


decodeCharacterResp : Decode.Decoder Model
decodeCharacterResp =
    Decode.map2 Model (Decode.at [ "data", "id" ] Decode.int) (Decode.at [ "data", "name" ] Decode.string)


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

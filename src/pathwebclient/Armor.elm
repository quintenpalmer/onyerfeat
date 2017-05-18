module Armor exposing (main)

import Html
import Html.Attributes as Attr
import Html
import Control
import View
import Http
import Models
import Decoding


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = SheetLoaded (Result Http.Error (List Models.ArmorPiece))


type alias Model =
    Result String (List Models.ArmorPiece)


init : ( Model, Cmd Msg )
init =
    ( Err "loading"
    , getArmorPieces
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SheetLoaded (Ok armorPieces) ->
            ( Ok armorPieces, Cmd.none )

        SheetLoaded (Err e) ->
            ( Err <| toString e, Cmd.none )


getArmorPieces : Cmd Msg
getArmorPieces =
    let
        url =
            "http://localhost:3000/api/armor_pieces"
    in
        Http.send SheetLoaded (Http.get url Decoding.decodeArmorPieces)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view mArmorPieces =
    Html.div []
        [ Html.node "link" [ Attr.rel "stylesheet", Attr.href "assets/bootstrap/css/bootstrap.min.css" ] []
        , Html.div [ Attr.class "container" ]
            [ case mArmorPieces of
                Err s ->
                    Html.text s

                Ok armorPieces ->
                    Html.div [ Attr.class "col-md-9" ]
                        [ Html.h2 [ Attr.class "text-center" ] [ Html.text "Armor" ]
                        , Html.table [ Attr.class "table table-striped table-bordered" ]
                            [ Html.thead []
                                [ Html.tr []
                                    [ Html.th [ Attr.class "text-center" ] [ Html.text "Armor Class" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Name" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Armor Bonus" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Max Dex Bonus" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Armor Check Penalty" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Fast Speed" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Slow Speed" ]
                                    , Html.th [ Attr.class "text-center" ] [ Html.text "Medium Weight" ]
                                    ]
                                ]
                            , Html.tbody [ Attr.class "text-center" ]
                                (List.map
                                    (\piece ->
                                        Html.tr []
                                            [ Html.td [] [ Html.b [] [ Html.text piece.armorClass ] ]
                                            , Html.td [] [ Html.b [] [ Html.text piece.name ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.armorBonus ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.maxDexBonus ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.armorCheckPenalty ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.fastSpeed ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.slowSpeed ] ]
                                            , Html.td [] [ Html.b [] [ Html.text <| toString piece.mediumWeight ] ]
                                            ]
                                    )
                                    armorPieces
                                )
                            ]
                        ]
            ]
        ]

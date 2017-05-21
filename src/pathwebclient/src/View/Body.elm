module View.Body exposing (view)

import Css
import Html
import Html.Attributes as Attr
import Html.Events as Events
import Common
import Models
import View.CharacterSheet as CharacterSheet
import View.ShieldTable as ShieldTable
import View.ArmorTable as ArmorTable
import View.DiceTab as DiceTab


cssStyle =
    Css.asPairs >> Attr.style


header =
    cssStyle
        [ Css.padding <| Css.px 20
        , Css.color <| Css.rgb 250 250 250
        , Css.backgroundColor <| Css.rgb 70 70 70
        ]


view : Models.Model -> Html.Html Common.Msg
view model =
    Html.div [ Attr.class "font-inc" ]
        [ Html.node "link" [ Attr.rel "stylesheet", Attr.href "/assets/bootstrap/css/bootstrap.min.css" ] []
        , Html.node "link" [ Attr.rel "stylesheet", Attr.href "/assets/css/style.css" ] []
        , Html.div
            [ header
            ]
            [ Html.text "Pathfinder Character Sheet" ]
        , Html.div [ Attr.class "container" ]
            [ Html.ul [ Attr.class "nav nav-pills" ]
                [ Html.li
                    (case model of
                        Models.MCharacter _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick <| Common.LoadCharacter 1 ] [ Html.text "Load Idrigoth" ] ]
                , Html.li
                    (case model of
                        Models.MShields _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.LoadShields ] [ Html.text "Load Shields" ] ]
                , Html.li
                    (case model of
                        Models.MArmorPieces _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.LoadArmorPieces ] [ Html.text "Load Armor" ] ]
                , Html.li
                    (case model of
                        Models.MDiceTab _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.DiceTab ] [ Html.text "Dice Rolls" ] ]
                ]
            , case model of
                Models.MCharacter c ->
                    CharacterSheet.displayCharacterSheet c

                Models.MError e ->
                    Html.h1 [] [ Html.text e ]

                Models.MNotLoaded ->
                    Html.h1 [] [ Html.text "Loading" ]

                Models.MShields ss ->
                    ShieldTable.displayShields ss

                Models.MArmorPieces pieces ->
                    ArmorTable.displayArmorPieces pieces

                Models.MDiceTab mRoll ->
                    DiceTab.displayDiceTab mRoll
            ]
        ]

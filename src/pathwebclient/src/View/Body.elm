module View.Body exposing (view)

import Html
import Html.Attributes as Attr
import Html.Events as Events
import Common
import Models
import View.CharacterSheet as CharacterSheet
import View.WeaponTable as WeaponTable
import View.ShieldTable as ShieldTable
import View.ArmorTable as ArmorTable
import View.DiceTab as DiceTab


view : Models.Model -> Html.Html Common.Msg
view model =
    Html.div [ Attr.class "font-inc" ]
        [ Html.node "link" [ Attr.rel "stylesheet", Attr.href "/assets/bootstrap/css/bootstrap.min.css" ] []
        , Html.node "link" [ Attr.rel "stylesheet", Attr.href "/assets/css/style.css" ] []
        , Html.div [ Attr.class "main-heading" ]
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
                        Models.MCharacter _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick <| Common.LoadCharacter 5 ] [ Html.text "Load Atolabsam" ] ]
                , Html.li
                    (case model of
                        Models.MCharacter _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick <| Common.LoadCharacter 6 ] [ Html.text "Load Charger" ] ]
                , Html.li
                    (case model of
                        Models.MCharacter _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick <| Common.LoadCharacter 7 ] [ Html.text "Load Amalgam" ] ]
                , Html.li
                    (case model of
                        Models.MWeapons _ ->
                            [ Attr.class "active", Attr.style [ ( "role", "presentation" ) ] ]

                        _ ->
                            [ Attr.style [ ( "role", "presentation" ) ] ]
                    )
                    [ Html.a [ Attr.href "#", Events.onClick Common.LoadWeapons ] [ Html.text "Load Weapons" ] ]
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

                Models.MWeapons weapons ->
                    WeaponTable.displayWeapons weapons

                Models.MShields ss ->
                    ShieldTable.displayShields ss

                Models.MArmorPieces pieces ->
                    ArmorTable.displayArmorPieces pieces

                Models.MDiceTab mRoll ->
                    DiceTab.displayDiceTab mRoll
            ]
        ]

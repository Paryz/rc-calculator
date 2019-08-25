module Page.RcBeam.Partials.Results exposing (template)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Page.RcBeam.Types exposing (Msg(..), StringedBeam)


template : StringedBeam -> Grid.Column Msg
template stringedBeam =
    Grid.col [ Col.xs12 ]
        [ button [ onClick <| SendToJs stringedBeam ] [ text "Print results" ]
        , div [ class "results" ]
            [ div [ id "fck" ] []
            , div [ id "fcm" ] []
            , div [ id "fctm" ] []
            , div [ id "eps2" ] []
            , div [ id "eps3" ] []
            , div [ id "concreteFactor" ] []
            , div [ id "alphacc" ] []
            , div [ id "fcd" ] []
            , div [ id "fyk" ] []
            , div [ id "steelFactor" ] []
            , div [ id "fyd" ] []
            , div [ id "concreteCover" ] []
            ]
        ]

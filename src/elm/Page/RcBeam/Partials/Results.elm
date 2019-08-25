module Page.RcBeam.Partials.Results exposing (template)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page.RcBeam.Types exposing (Msg(..), StringedBeam)


template : StringedBeam -> Grid.Column Msg
template stringedBeam =
    Grid.col [ Col.xs12 ]
        [ button [ onClick <| SendToJs stringedBeam ] [ text "Print results" ]
        , div [ class "results" ]
            [ div [ class "fck" ] []
            , div [ class "fcm" ] []
            ]
        ]

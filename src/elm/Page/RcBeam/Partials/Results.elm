module Page.RcBeam.Partials.Results exposing (template)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class, id, type_)
import Html.Events exposing (onClick)
import Page.RcBeam.Types exposing (Msg(..), StringedBeam)


template : StringedBeam -> Grid.Column Msg
template stringedBeam =
    Grid.col [ Col.xs12 ]
        [ div [ id "results" ] [] ]

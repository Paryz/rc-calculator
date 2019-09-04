module Page.RcBeam.Partials.Results exposing (template)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (div)
import Html.Attributes exposing (id)
import Page.RcBeam.Types exposing (Msg(..))


template : Grid.Column Msg
template =
    Grid.col [ Col.xs12 ]
        [ div [ id "results" ] [] ]

module Page.RcBeam.Partials.Optimizer exposing (render)

import Bootstrap.Table as Table
import Html exposing (Html, h4, text)
import Html.Attributes exposing (class)
import Page.RcBeam.Types exposing (OptimizationSolution)
import Round


render : List OptimizationSolution -> Html msg
render solutions =
    if List.isEmpty solutions then
        text "No feasible optimization candidates found for given inputs."

    else
        Html.div []
            [ h4 [] [ text "Optimized Beam Options" ]
            , Html.div [ class "table-responsive optimizer-table-wrapper" ]
                [ Table.table
                    { options = [ Table.small, Table.striped, Table.hover ]
                    , thead =
                        Table.simpleThead
                            [ Table.th [] [ text "b (mm)" ]
                            , Table.th [] [ text "h (mm)" ]
                            , Table.th [] [ text "φ (mm)" ]
                            , Table.th [] [ text "φs (mm)" ]
                            , Table.th [] [ text "Top bars" ]
                            , Table.th [] [ text "Bottom bars" ]
                            , Table.th [] [ text "As,req" ]
                            , Table.th [] [ text "As,prov" ]
                            , Table.th [] [ text "Util." ]
                            ]
                    , tbody =
                        Table.tbody [] (List.map row solutions)
                    }
                ]
            ]


row : OptimizationSolution -> Table.Row msg
row solution =
    Table.tr []
        [ Table.td [] [ text <| String.fromInt solution.width ]
        , Table.td [] [ text <| String.fromInt solution.height ]
        , Table.td [] [ text <| String.fromInt solution.diameter ]
        , Table.td [] [ text <| String.fromInt solution.stirrupDiameter ]
        , Table.td [] [ text <| String.fromInt solution.topBars ]
        , Table.td [] [ text <| String.fromInt solution.bottomBars ]
        , Table.td [] [ text <| String.fromInt solution.requiredAs ]
        , Table.td [] [ text <| String.fromInt solution.providedAs ]
        , Table.td [] [ text <| Round.round 3 solution.utilization ]
        ]

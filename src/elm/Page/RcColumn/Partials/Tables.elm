module Page.RcColumn.Partials.Tables exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Html exposing (Html, text)
import Html.Attributes exposing (class)


render : Float -> List (Grid.Column msg)
render requiredReinforcement =
    [ Grid.col [ Col.xs12 ]
        [ barSectionTable (ceiling requiredReinforcement) ]
    ]


barSectionTable : Int -> Html msg
barSectionTable reqReinforcement =
    let
        phi =
            String.fromChar <| Char.fromCode 966

        counts =
            List.range 4 16

        headerCells =
            List.map (\count -> Table.th [] [ text <| String.fromInt count ]) counts

        tableRow diameter =
            let
                rowCells =
                    List.map
                        (\count ->
                            let
                                section =
                                    barSection diameter count

                                color =
                                    if section >= reqReinforcement then
                                        Table.cellSuccess

                                    else
                                        Table.cellDanger
                            in
                            Table.td [ color, Table.cellAttr <| class "reinforcement-table-cell" ] [ text <| String.fromInt section ]
                        )
                        counts
            in
            Table.tr [] (Table.td [] [ text <| String.fromInt diameter ] :: rowCells)
    in
    Table.table
        { options = [ Table.small ]
        , thead =
            Table.simpleThead
                (Table.th [] [ text phi ] :: headerCells)
        , tbody =
            Table.tbody []
                [ tableRow 12
                , tableRow 16
                , tableRow 20
                , tableRow 25
                , tableRow 32
                , tableRow 40
                , tableRow 50
                ]
        }


barSection : Int -> Int -> Int
barSection diameter count =
    let
        area =
            pi * toFloat diameter ^ 2 / 4
    in
    round (area * toFloat count)

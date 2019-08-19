module Page.RcBeam.Partials.Tables exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Calculator.Diameters as Diameters exposing (BarSectionsList)
import Html exposing (Html, text)


render : Int -> Int -> List (Grid.Column msg)
render top bottom =
    if top > 0 && bottom > 0 then
        [ Grid.col [ Col.xs6 ]
            [ barSectionTable top ]
        , Grid.col [ Col.xs6 ]
            [ barSectionTable bottom ]
        ]

    else if top == 0 && bottom > 0 then
        [ Grid.col [ Col.xs8 ]
            [ barSectionTable bottom ]
        ]

    else
        [ Grid.col [ Col.xs12 ] [ text "Geometry you provided has errors" ] ]


barSectionTable : Int -> Html msg
barSectionTable reqReinforcement =
    let
        phi =
            String.fromChar <| Char.fromCode 966
    in
    Table.table
        { options = [ Table.small ]
        , thead =
            Table.simpleThead
                [ Table.th [] [ text phi ]
                , Table.th [] [ text "1" ]
                , Table.th [] [ text "2" ]
                , Table.th [] [ text "3" ]
                , Table.th [] [ text "4" ]
                , Table.th [] [ text "5" ]
                , Table.th [] [ text "6" ]
                , Table.th [] [ text "7" ]
                , Table.th [] [ text "8" ]
                , Table.th [] [ text "9" ]
                , Table.th [] [ text "10" ]
                ]
        , tbody =
            Table.tbody []
                [ tableRow .m12 Diameters.listOfBarSection "12" reqReinforcement
                , tableRow .m16 Diameters.listOfBarSection "16" reqReinforcement
                , tableRow .m20 Diameters.listOfBarSection "20" reqReinforcement
                , tableRow .m25 Diameters.listOfBarSection "25" reqReinforcement
                , tableRow .m32 Diameters.listOfBarSection "32" reqReinforcement
                , tableRow .m40 Diameters.listOfBarSection "40" reqReinforcement
                , tableRow .m50 Diameters.listOfBarSection "50" reqReinforcement
                ]
        }


tableRow : (BarSectionsList -> List Int) -> BarSectionsList -> String -> Int -> Table.Row msg
tableRow function listOfSections bar reqReinforcement =
    let
        firstSixElementsOfList =
            List.take 10 (function listOfSections)

        mappedCells =
            List.map
                (\section ->
                    let
                        color =
                            if section > reqReinforcement then
                                Table.cellSuccess

                            else
                                Table.cellDanger
                    in
                    Table.td [ color ] [ text <| String.fromInt section ]
                )
                firstSixElementsOfList

        row =
            Table.td [] [ text bar ] :: mappedCells
    in
    Table.tr [] row

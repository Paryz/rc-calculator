module Page.RcBeam.View exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Table as Table
import Calculator.Diameters as Diameters exposing (BarSectionsList)
import Html exposing (Html, div, text)
import Page.RcBeam.Model exposing (Field(..), Model, Msg(..))
import Page.RcBeam.Partials.BeamDrawing exposing (beamDrawing)
import Page.RcBeam.Translator exposing (translate)
import Page.RcBeam.View.Form as Form


view : Model -> { title : String, content : Html Msg }
view model =
    let
        ( top, bottom ) =
            model.reinforcement

        totalReqReinforcement =
            Basics.toFloat <| bottom + top

        translatedBeam =
            translate model.beam

        svgBeamDrawing =
            beamDrawing translatedBeam model.reinforcement

        reinforcementRequiredToString =
            let
                maximumReinforcement =
                    model.maximumReinforcement
            in
            if top < 0 || bottom < 0 || maximumReinforcement < totalReqReinforcement then
                "Please provide bigger section"

            else
                "Top Reinforcement = " ++ String.fromInt top ++ ", Bottom Reinforcement = " ++ String.fromInt bottom
    in
    { title = model.pageTitle
    , content =
        Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.middleXs, Col.xs6 ]
                    [ Form.view model ]
                , Grid.col [ Col.middleXs, Col.xs6 ]
                    [ svgBeamDrawing ]
                ]
            , Grid.row [ Row.centerMd ]
                [ Grid.col [ Col.xs12 ]
                    [ div [] [ text reinforcementRequiredToString ] ]
                ]
            , Grid.row [ Row.centerMd ]
                (renderTables top bottom)
            ]
    }


renderTables : Int -> Int -> List (Grid.Column msg)
renderTables top bottom =
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
                ]
        , tbody =
            Table.tbody []
                [ tableRow .m12 Diameters.listOfBarSection "12" reqReinforcement
                , tableRow .m16 Diameters.listOfBarSection "16" reqReinforcement
                , tableRow .m20 Diameters.listOfBarSection "20" reqReinforcement
                , tableRow .m25 Diameters.listOfBarSection "25" reqReinforcement
                , tableRow .m32 Diameters.listOfBarSection "32" reqReinforcement
                ]
        }


tableRow : (BarSectionsList -> List Int) -> BarSectionsList -> String -> Int -> Table.Row msg
tableRow function listOfSections bar reqReinforcement =
    let
        firstSixElementsOfList =
            List.take 8 (function listOfSections)

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

module Page.RcBeam.View exposing (view)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Table as Table
import Calculator.Classes as Classes
import Calculator.Diameters as Diameters exposing (BarSectionsList)
import Calculator.Factors as Factors
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page.RcBeam.Model exposing (Field(..), Model, Msg(..))
import Page.RcBeam.Partials.BeamDrawing exposing (beamDrawing)
import Page.RcBeam.Translator exposing (translate)


view : Model -> { title : String, content : Html Msg }
view model =
    let
        gamma =
            String.fromChar (Char.fromCode 947)

        concreteClassesToSelect =
            List.map
                (\( cube, cylinder ) ->
                    if cube == 30 then
                        Select.item [ value <| String.fromInt cube, selected True ]
                            [ text <| String.fromInt cube ++ "/" ++ String.fromInt cylinder ]

                    else
                        Select.item [ value <| String.fromInt cube ]
                            [ text <| String.fromInt cube ++ "/" ++ String.fromInt cylinder ]
                )
                Classes.concrete

        steelClassesToSelect =
            mapItemFromFloatWithDefault Classes.steel 500

        linBarDiametersToSelect =
            mapItemFromFloatWithDefault Diameters.barDiameters 10

        mainBarDiametersToSelect =
            mapItemFromFloatWithDefault Diameters.barDiameters 20

        concreteFactorsToSelect =
            mapItemFromFloat Factors.concrete

        steelFactorsToSelect =
            mapItemFromFloat Factors.steel

        ( top, bottom ) =
            model.reinforcement

        totalReqReinforcement =
            Basics.toFloat <| bottom + top

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
                    [ Form.form []
                        [ Form.row []
                            [ Form.col [ Col.xs6 ]
                                [ Form.label [ for "height" ] [ text "height - h (mm)" ]
                                , Input.number
                                    [ Input.id "width"
                                    , Input.onInput (\height -> Update Height height)
                                    , Input.value model.beam.height
                                    , Input.attrs
                                        [ Html.Attributes.max "1000"
                                        , Html.Attributes.min "0"
                                        ]
                                    ]
                                , input
                                    [ type_ "range"
                                    , Html.Attributes.min "100"
                                    , Html.Attributes.max "2000"
                                    , Html.Attributes.step "10"
                                    , value model.beam.height
                                    , onInput (Update Height)
                                    ]
                                    []
                                ]
                            , Form.col [ Col.xs6 ]
                                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                                , Input.number
                                    [ Input.id "width"
                                    , Input.onInput (\width -> Update Width width)
                                    , Input.value model.beam.width
                                    ]
                                , input
                                    [ type_ "range"
                                    , Html.Attributes.min "100"
                                    , Html.Attributes.max "1000"
                                    , Html.Attributes.step "10"
                                    , value model.beam.width
                                    , onInput (Update Width)
                                    ]
                                    []
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs6 ]
                                [ Form.label [ for "cover" ]
                                    [ text "cover - c"
                                    , sub [] [ text "nom" ]
                                    , text " (mm)"
                                    ]
                                , Input.number
                                    [ Input.id "cover"
                                    , Input.onInput (\cover -> Update Cover cover)
                                    , Input.value model.beam.cover
                                    ]
                                , input
                                    [ type_ "range"
                                    , Html.Attributes.min "10"
                                    , Html.Attributes.max "100"
                                    , Html.Attributes.step "5"
                                    , value model.beam.cover
                                    , onInput (Update Cover)
                                    ]
                                    []
                                ]
                            , Form.col [ Col.xs6 ]
                                [ Form.label [ for "bending-moment" ]
                                    [ text "bending moment - M"
                                    , sub [] [ text "ed" ]
                                    ]
                                , Input.number
                                    [ Input.id "bending-moment"
                                    , Input.onInput (\moment -> Update BendingMoment moment)
                                    , Input.value model.beam.bendingMoment
                                    ]
                                , input
                                    [ type_ "range"
                                    , Html.Attributes.min "100"
                                    , Html.Attributes.max "5000"
                                    , Html.Attributes.step "50"
                                    , value model.beam.bendingMoment
                                    , onInput (Update BendingMoment)
                                    ]
                                    []
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs6 ]
                                [ Form.label [ for "link-bar-diameter" ]
                                    [ text "link bar diameter (mm)" ]
                                , Select.select
                                    [ Select.id "link-bar-diameter"
                                    , Select.onChange (\diameter -> Update LinBarDiameter diameter)
                                    ]
                                    linBarDiametersToSelect
                                ]
                            , Form.col [ Col.xs6 ]
                                [ Form.label [ for "main-bar-diameter" ]
                                    [ text "main bar diameter (mm)" ]
                                , Select.select
                                    [ Select.id "main-bar-diameter"
                                    , Select.onChange (\diameter -> Update MainBarDiameter diameter)
                                    ]
                                    mainBarDiametersToSelect
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs6 ]
                                [ Form.label [ for "concrete-class" ]
                                    [ text "concrete class (MPa)" ]
                                , Select.select
                                    [ Select.id "concrete-class"
                                    , Select.onChange (\concreteClass -> Update ConcreteClass concreteClass)
                                    ]
                                    concreteClassesToSelect
                                ]
                            , Form.col [ Col.xs6 ]
                                [ Form.label [ for "steel-class" ]
                                    [ text "steel class (MPa)" ]
                                , Select.select
                                    [ Select.id "steel-class"
                                    , Select.onChange (\steelClass -> Update SteelClass steelClass)
                                    ]
                                    steelClassesToSelect
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs6 ]
                                [ Form.label [ for "gammaC" ]
                                    [ text "concrete - "
                                    , text gamma
                                    , sub [] [ text "c" ]
                                    ]
                                , Select.select
                                    [ Select.id "gammaC"
                                    , Select.onChange (\concreteFactor -> Update ConcreteFactor concreteFactor)
                                    ]
                                    concreteFactorsToSelect
                                ]
                            , Form.col [ Col.xs6 ]
                                [ Form.label [ for "gammaS" ]
                                    [ text "steel - "
                                    , text gamma
                                    , sub [] [ text "s" ]
                                    ]
                                , Select.select
                                    [ Select.id "gammaS"
                                    , Select.onChange (\steelFactor -> Update SteelFactor steelFactor)
                                    ]
                                    steelFactorsToSelect
                                ]
                            ]
                        ]
                    ]
                , Grid.col [ Col.middleXs, Col.xs6 ]
                    [ beamDrawing (translate model.beam) ]
                ]
            , Grid.row [ Row.centerMd ]
                [ Grid.col [ Col.xs12 ]
                    [ div [] [ text reinforcementRequiredToString ]
                    ]
                ]
            , Grid.row [ Row.centerMd ]
                (renderTables top bottom)
            ]
    }


mapItemFromFloat : List Float -> List (Select.Item msg)
mapItemFromFloat collection =
    List.map
        (\item -> Select.item [ value <| String.fromFloat item ] [ text <| String.fromFloat item ])
        collection


mapItemFromFloatWithDefault : List Int -> Int -> List (Select.Item msg)
mapItemFromFloatWithDefault collection itemValue =
    List.map
        (\item ->
            if item == itemValue then
                Select.item [ value <| String.fromInt item, selected True ]
                    [ text <| String.fromInt item ]

            else
                Select.item [ value <| String.fromInt item ]
                    [ text <| String.fromInt item ]
        )
        collection


renderTables : Int -> Int -> List (Grid.Column msg)
renderTables top bottom =
    if top > 0 && bottom > 0 then
        [ Grid.col [ Col.xs6 ]
            [ barSectionTable Diameters.listOfBarSection top ]
        , Grid.col [ Col.xs6 ]
            [ barSectionTable Diameters.listOfBarSection bottom ]
        ]

    else if top == 0 && bottom > 0 then
        [ Grid.col [ Col.xs8 ]
            [ barSectionTable Diameters.listOfBarSection bottom ]
        ]

    else
        [ Grid.col [ Col.xs12 ] [ text "Geometry you provided has errors" ] ]


barSectionTable : BarSectionsList -> Int -> Html msg
barSectionTable barSectionList reqReinforcement =
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
            [ Table.td [] [ text bar ] ] ++ mappedCells
    in
    Table.tr [] row

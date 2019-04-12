module Page.Views.RcBeamView exposing (view)

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
import Page.RcBeam exposing (Field(..), Model, Msg(..))


view : Model -> { title : String, content : Html Msg }
view model =
    let
        gamma =
            String.fromChar (Char.fromCode 947)

        concreteClassesToSelect =
            List.map
                (\( cube, cylinder ) ->
                    if cube == 30 then
                        Select.item [ value (String.fromInt cube), selected True ]
                            [ text (String.fromInt cube ++ "/" ++ String.fromInt cylinder) ]

                    else
                        Select.item [ value (String.fromInt cube) ]
                            [ text (String.fromInt cube ++ "/" ++ String.fromInt cylinder) ]
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
            Basics.toFloat (bottom + top)

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
                [ Grid.col [ Col.middleXs, Col.xs8 ]
                    [ Form.form []
                        [ Form.row []
                            [ Form.col [ Col.xs4 ]
                                [ Form.label [ for "height" ] [ text "height - h (mm)" ]
                                , Input.text
                                    [ Input.id "width"
                                    , Input.onInput (\height -> Update Height height)
                                    , Input.value model.beam.height
                                    , Input.attrs [ type_ "number" ]
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                                , Input.text
                                    [ Input.id "width"
                                    , Input.onInput (\width -> Update Width width)
                                    , Input.value model.beam.width
                                    , Input.attrs [ type_ "number" ]
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "cover" ]
                                    [ text "cover - c"
                                    , sub [] [ text "nom" ]
                                    , text " (mm)"
                                    ]
                                , Input.text
                                    [ Input.id "cover"
                                    , Input.onInput (\cover -> Update Cover cover)
                                    , Input.value model.beam.cover
                                    , Input.attrs [ type_ "number" ]
                                    ]
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs3 ]
                                [ Form.label [ for "link-bar-diameter" ]
                                    [ text "link bar diameter (mm)" ]
                                , Select.select
                                    [ Select.id "link-bar-diameter"
                                    , Select.onChange (\diameter -> Update LinBarDiameter diameter)
                                    ]
                                    linBarDiametersToSelect
                                ]
                            , Form.col [ Col.xs3 ]
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
                            [ Form.col [ Col.xs3 ]
                                [ Form.label [ for "concrete-class" ]
                                    [ text "concrete class (MPa)" ]
                                , Select.select
                                    [ Select.id "concrete-class"
                                    , Select.onChange (\concreteClass -> Update ConcreteClass concreteClass)
                                    ]
                                    concreteClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "steel-class" ]
                                    [ text "steel class (MPa)" ]
                                , Select.select
                                    [ Select.id "steel-class"
                                    , Select.onChange (\steelClass -> Update SteelClass steelClass)
                                    ]
                                    steelClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
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
                            , Form.col [ Col.xs3 ]
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
                        , Form.row []
                            [ Form.col [ Col.xs4 ]
                                [ Form.label [ for "bending-moment" ]
                                    [ text "bending moment - M"
                                    , sub [] [ text "ed" ]
                                    ]
                                , Input.text
                                    [ Input.id "bending-moment"
                                    , Input.onInput (\bendingMoment -> Update BendingMoment bendingMoment)
                                    , Input.value model.beam.bendingMoment
                                    , Input.attrs [ type_ "number" ]
                                    ]
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs12 ]
                                [ Form.label [ for "result" ] [ text "result - (mm)" ]
                                , Input.text
                                    [ Input.id "result"
                                    , Input.disabled True
                                    , Input.value reinforcementRequiredToString
                                    ]
                                ]
                            ]
                        ]
                    ]
                , Grid.col [ Col.middleXs, Col.xs4 ]
                    [ h1 [] [ text "test" ] ]
                ]
            , barSectionTable Diameters.listOfBarSection totalReqReinforcement
            ]
    }


mapItemFromFloat : List Float -> List (Select.Item msg)
mapItemFromFloat collection =
    List.map
        (\item -> Select.item [ value (String.fromFloat item) ] [ text (String.fromFloat item) ])
        collection


mapItemFromFloatWithDefault : List Int -> Int -> List (Select.Item msg)
mapItemFromFloatWithDefault collection itemValue =
    List.map
        (\item ->
            if item == itemValue then
                Select.item [ value (String.fromInt item), selected True ]
                    [ text (String.fromInt item) ]

            else
                Select.item [ value (String.fromInt item) ]
                    [ text (String.fromInt item) ]
        )
        collection


barSectionTable : BarSectionsList -> Float -> Html msg
barSectionTable barSectionList reqReinforcement =
    Table.simpleTable
        ( Table.simpleThead
            [ Table.th [] [ text "Diameter" ]
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
        , Table.tbody []
            [ tableRow .m6 Diameters.listOfBarSection "M6" reqReinforcement
            , tableRow .m8 Diameters.listOfBarSection "M8" reqReinforcement
            , tableRow .m10 Diameters.listOfBarSection "M10" reqReinforcement
            , tableRow .m12 Diameters.listOfBarSection "M12" reqReinforcement
            , tableRow .m16 Diameters.listOfBarSection "M16" reqReinforcement
            , tableRow .m20 Diameters.listOfBarSection "M20" reqReinforcement
            , tableRow .m25 Diameters.listOfBarSection "M25" reqReinforcement
            , tableRow .m32 Diameters.listOfBarSection "M32" reqReinforcement
            , tableRow .m40 Diameters.listOfBarSection "M40" reqReinforcement
            , tableRow .m50 Diameters.listOfBarSection "M50" reqReinforcement
            ]
        )


tableRow : (BarSectionsList -> List Float) -> BarSectionsList -> String -> Float -> Table.Row msg
tableRow function listOfSections bar reqReinforcement =
    let
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
                    Table.td [ color ] [ text (String.fromFloat section) ]
                )
                (function listOfSections)

        row =
            [ Table.td [] [ text bar ] ] ++ mappedCells
    in
    Table.tr [] row

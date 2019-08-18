module Page.RcBeam.Partials.Form exposing (render)

import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid.Col as Col
import Calculator.Classes as Classes
import Calculator.Diameters as Diameters
import Calculator.Factors as Factors
import Html exposing (input, sub, text)
import Html.Attributes exposing (for, selected, type_, value)
import Html.Events exposing (onInput)
import Page.RcBeam.Types exposing (Field(..), Msg(..), StringedBeam)


render : StringedBeam -> Html.Html Msg
render beam =
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
    in
    Form.form []
        [ Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "height" ] [ text "height - h (mm)" ]
                , Input.number
                    [ Input.id "width"
                    , Input.onInput (\height -> Update Height height)
                    , Input.value beam.height
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
                    , value beam.height
                    , onInput (Update Height)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                , Input.number
                    [ Input.id "width"
                    , Input.onInput (\width -> Update Width width)
                    , Input.value beam.width
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "100"
                    , Html.Attributes.max "1000"
                    , Html.Attributes.step "10"
                    , value beam.width
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
                    , Input.value beam.cover
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "10"
                    , Html.Attributes.max "100"
                    , Html.Attributes.step "5"
                    , value beam.cover
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
                    , Input.value beam.bendingMoment
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "100"
                    , Html.Attributes.max "5000"
                    , Html.Attributes.step "50"
                    , value beam.bendingMoment
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

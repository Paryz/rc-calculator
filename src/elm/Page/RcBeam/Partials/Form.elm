module Page.RcBeam.Partials.Form exposing (render)

import Bootstrap.Form as Form
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Select as Select
import Bootstrap.Grid.Col as Col
import Calculator.Classes as Classes
import Calculator.Diameters as Diameters
import Calculator.Factors as Factors
import Html exposing (div, input, label, sub, text)
import Html.Attributes exposing (class, for, selected, type_, value)
import Html.Events exposing (onClick, onInput)
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
    in
    Form.form []
        [ Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "height" ] [ text "h (mm)" ]
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
                    , class "slider"
                    , value beam.height
                    , onInput (Update Height)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "width" ] [ text "b (mm)" ]
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
                    , class "slider"
                    , value beam.width
                    , onInput (Update Width)
                    ]
                    []
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "cover" ]
                    [ text "c"
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
                    , class "slider"
                    , value beam.cover
                    , onInput (Update Cover)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "bending-moment" ]
                    [ text "M"
                    , sub [] [ text "ed" ]
                    , text " (MPa)"
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
                    , class "slider"
                    , value beam.bendingMoment
                    , onInput (Update BendingMoment)
                    ]
                    []
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "link-bar-diameter" ]
                    [ text "links (mm)" ]
                , Select.select
                    [ Select.id "link-bar-diameter"
                    , Select.onChange (\diameter -> Update LinkBarDiameter diameter)
                    ]
                    linBarDiametersToSelect
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "main-bar-diameter" ]
                    [ text "main bar(mm)" ]
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
                    [ text "f"
                    , sub [] [ text "ck" ]
                    , text " (MPa)"
                    ]
                , Select.select
                    [ Select.id "concrete-class"
                    , Select.onChange (\concreteClass -> Update ConcreteClass concreteClass)
                    ]
                    concreteClassesToSelect
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "steel-class" ]
                    [ text "f"
                    , sub [] [ text "yk" ]
                    , text " (MPa)"
                    ]
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
                    [ text gamma
                    , sub [] [ text "c" ]
                    ]
                , div [ class "switch-field" ]
                    [ input
                        [ type_ "radio"
                        , Html.Attributes.id "concreteFactorOne"
                        , Html.Attributes.checked <| radioFactorChecked beam.concreteFactor "1.5"
                        , onClick (Update ConcreteFactor "1.5")
                        , Html.Attributes.class "switch-one"
                        ]
                        []
                    , label [ for "concreteFactorOne" ] [ text "1.5" ]
                    , input
                        [ type_ "radio"
                        , Html.Attributes.id "concreteFactorTwo"
                        , Html.Attributes.checked <| radioFactorChecked beam.concreteFactor "1.2"
                        , onClick (Update ConcreteFactor "1.2")
                        , Html.Attributes.class "switch-two"
                        ]
                        []
                    , label [ for "concreteFactorTwo" ] [ text "1.2" ]
                    ]
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "gammaS" ]
                    [ text gamma
                    , sub [] [ text "s" ]
                    ]
                , div [ class "switch-field" ]
                    [ input
                        [ type_ "radio"
                        , Html.Attributes.id "steelFactorOne"
                        , Html.Attributes.checked <| radioFactorChecked beam.steelFactor "1.15"
                        , onClick (Update SteelFactor "1.15")
                        , Html.Attributes.class "switch-one"
                        ]
                        []
                    , label [ for "steelFactorOne" ] [ text "1.15" ]
                    , input
                        [ type_ "radio"
                        , Html.Attributes.id "steelFactorTwo"
                        , Html.Attributes.checked <| radioFactorChecked beam.steelFactor "1.0"
                        , onClick (Update SteelFactor "1.0")
                        , Html.Attributes.class "switch-two"
                        ]
                        []
                    , label [ for "steelFactorTwo" ] [ text "1.0" ]
                    ]
                ]
            ]
        ]


radioFactorChecked : String -> String -> Bool
radioFactorChecked factor target =
    if factor == target then
        True

    else
        False


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

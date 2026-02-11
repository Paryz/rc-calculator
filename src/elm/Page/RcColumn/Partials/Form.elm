module Page.RcColumn.Partials.Form exposing (render)

import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid.Col as Col
import Calculator.Classes as Classes
import Calculator.Diameters as Diameters
import Html exposing (div, input, label, sub, text)
import Html.Attributes exposing (class, for, selected, type_, value)
import Html.Events exposing (onClick, onInput)
import Page.RcColumn.Types exposing (Field(..), Msg(..), StringedColumn)


render : StringedColumn -> Html.Html Msg
render column =
    let
        gamma =
            String.fromChar (Char.fromCode 947)

        alpha =
            String.fromChar (Char.fromCode 945)

        phi =
            String.fromChar (Char.fromCode 966)

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
            mapItemFromIntWithDefault Classes.steel 500

        mainBarDiametersToSelect =
            mapItemFromIntWithDefault Diameters.barDiameters 20

        barsCountToSelect =
            mapItemFromIntWithDefault [ 4, 6, 8, 10, 12, 14, 16 ] 8
    in
    Form.form []
        [ Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "height" ] [ text "h (mm)" ]
                , Input.number
                    [ Input.id "height"
                    , Input.onInput (Update Height)
                    , Input.value column.height
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "200"
                    , Html.Attributes.max "1200"
                    , Html.Attributes.step "10"
                    , class "slider"
                    , value column.height
                    , onInput (Update Height)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "width" ] [ text "b (mm)" ]
                , Input.number
                    [ Input.id "width"
                    , Input.onInput (Update Width)
                    , Input.value column.width
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "200"
                    , Html.Attributes.max "1000"
                    , Html.Attributes.step "10"
                    , class "slider"
                    , value column.width
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
                    , Input.onInput (Update Cover)
                    , Input.value column.cover
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "20"
                    , Html.Attributes.max "80"
                    , Html.Attributes.step "5"
                    , class "slider"
                    , value column.cover
                    , onInput (Update Cover)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "main-bar-diameter" ]
                    [ text phi
                    , text " (mm)"
                    ]
                , Select.select
                    [ Select.id "main-bar-diameter"
                    , Select.onChange (Update MainBarDiameter)
                    ]
                    mainBarDiametersToSelect
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "bars-count" ] [ text "Number of bars" ]
                , Select.select
                    [ Select.id "bars-count"
                    , Select.onChange (Update BarsCount)
                    ]
                    barsCountToSelect
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "axial-force" ]
                    [ text "N"
                    , sub [] [ text "Ed" ]
                    , text " (kN)"
                    ]
                , Input.number
                    [ Input.id "axial-force"
                    , Input.onInput (Update AxialForce)
                    , Input.value column.axialForce
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "100"
                    , Html.Attributes.max "5000"
                    , Html.Attributes.step "50"
                    , class "slider"
                    , value column.axialForce
                    , onInput (Update AxialForce)
                    ]
                    []
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "bending-moment" ]
                    [ text "M"
                    , sub [] [ text "Ed" ]
                    , text " (kNm)"
                    ]
                , Input.number
                    [ Input.id "bending-moment"
                    , Input.onInput (Update BendingMoment)
                    , Input.value column.bendingMoment
                    ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "10"
                    , Html.Attributes.max "1000"
                    , Html.Attributes.step "10"
                    , class "slider"
                    , value column.bendingMoment
                    , onInput (Update BendingMoment)
                    ]
                    []
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "concrete-class" ]
                    [ text "f"
                    , sub [] [ text "ck" ]
                    , text " (MPa)"
                    ]
                , Select.select
                    [ Select.id "concrete-class"
                    , Select.onChange (Update ConcreteClass)
                    ]
                    concreteClassesToSelect
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs6 ]
                [ Form.label [ for "steel-class" ]
                    [ text "f"
                    , sub [] [ text "yk" ]
                    , text " (MPa)"
                    ]
                , Select.select
                    [ Select.id "steel-class"
                    , Select.onChange (Update SteelClass)
                    ]
                    steelClassesToSelect
                ]
            , Form.col [ Col.xs6 ]
                [ Form.label [ for "alphaCC" ]
                    [ text alpha
                    , sub [] [ text "cc" ]
                    ]
                , div [ class "switch-field" ]
                    [ input
                        [ type_ "radio"
                        , Html.Attributes.id "columnAlphaCCOne"
                        , Html.Attributes.checked <| radioFactorChecked column.alphaCC "0.85"
                        , onClick (Update AlphaCC "0.85")
                        ]
                        []
                    , label [ for "columnAlphaCCOne" ] [ text "0.85" ]
                    , input
                        [ type_ "radio"
                        , Html.Attributes.id "columnAlphaCCTwo"
                        , Html.Attributes.checked <| radioFactorChecked column.alphaCC "1.0"
                        , onClick (Update AlphaCC "1.0")
                        ]
                        []
                    , label [ for "columnAlphaCCTwo" ] [ text "1.0" ]
                    ]
                ]
            ]
        , Form.row []
            [ Form.col [ Col.xs12, Col.md6 ]
                [ Form.label [ for "gammaS" ]
                    [ text gamma
                    , sub [] [ text "s" ]
                    ]
                , div [ class "switch-field" ]
                    [ input
                        [ type_ "radio"
                        , Html.Attributes.id "columnSteelFactorOne"
                        , Html.Attributes.checked <| radioFactorChecked column.steelFactor "1.15"
                        , onClick (Update SteelFactor "1.15")
                        ]
                        []
                    , label [ for "columnSteelFactorOne" ] [ text "1.15" ]
                    , input
                        [ type_ "radio"
                        , Html.Attributes.id "columnSteelFactorTwo"
                        , Html.Attributes.checked <| radioFactorChecked column.steelFactor "1.0"
                        , onClick (Update SteelFactor "1.0")
                        ]
                        []
                    , label [ for "columnSteelFactorTwo" ] [ text "1.0" ]
                    ]
                ]
            , Form.col [ Col.xs12, Col.md6 ]
                [ Form.label [ for "gammaC" ]
                    [ text gamma
                    , sub [] [ text "c" ]
                    ]
                , div [ class "switch-field" ]
                    [ input
                        [ type_ "radio"
                        , Html.Attributes.id "columnConcreteFactorOne"
                        , Html.Attributes.checked <| radioFactorChecked column.concreteFactor "1.5"
                        , onClick (Update ConcreteFactor "1.5")
                        ]
                        []
                    , label [ for "columnConcreteFactorOne" ] [ text "1.5" ]
                    , input
                        [ type_ "radio"
                        , Html.Attributes.id "columnConcreteFactorTwo"
                        , Html.Attributes.checked <| radioFactorChecked column.concreteFactor "1.4"
                        , onClick (Update ConcreteFactor "1.4")
                        ]
                        []
                    , label [ for "columnConcreteFactorTwo" ] [ text "1.4" ]
                    ]
                ]
            ]
        ]


radioFactorChecked : String -> String -> Bool
radioFactorChecked factor target =
    factor == target


mapItemFromIntWithDefault : List Int -> Int -> List (Select.Item msg)
mapItemFromIntWithDefault collection itemValue =
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

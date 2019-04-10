module Page.Views.RcBeamView exposing (view)

import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Classes as Classes
import Calculator.Factors as Factors
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page.RcBeam exposing (Model, Msg(..))


view : Model -> { title : String, content : Html Msg }
view model =
    let
        gamma =
            String.fromChar (Char.fromCode 947)

        concreteClassesToSelect =
            List.map
                (\( cube, cylinder ) -> Select.item [ value (String.fromInt cube) ] [ text (String.fromInt cube ++ "/" ++ String.fromInt cylinder) ])
                Classes.concrete

        steelClassesToSelect =
            mapItemFromNumber Classes.steel String.fromInt

        concreteFactorsToSelect =
            mapItemFromNumber Factors.concrete String.fromFloat

        steelFactorsToSelect =
            mapItemFromNumber Factors.steel String.fromFloat

        reinforcementRequiredToString =
            let
                ( top, bottom ) =
                    model.beam.reinforcementRequired
            in
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
                                    , Input.onInput (\height -> UpdateHeight height)
                                    , Input.value model.beam.height
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                                , Input.text
                                    [ Input.id "width"
                                    , Input.onInput (\width -> UpdateHeight width)
                                    , Input.value model.beam.width
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "cover" ]
                                    [ text "cover - c"
                                    , sub [] [ text "nom" ]
                                    , text " (mm)"
                                    ]
                                , Input.text [ Input.id "width" ]
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs3 ]
                                [ Form.label [ for "concrete-class" ]
                                    [ text "concrete class (MPa)" ]
                                , Select.select
                                    [ Select.id "concrete-class"
                                    ]
                                    concreteClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "steel-class" ]
                                    [ text "steel class (MPa)" ]
                                , Select.select [ Select.id "steel-class" ]
                                    steelClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaC" ]
                                    [ text "concrete - "
                                    , text gamma
                                    , sub [] [ text "c" ]
                                    ]
                                , Select.select [ Select.id "gammaC" ]
                                    concreteFactorsToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaS" ]
                                    [ text "steel - "
                                    , text gamma
                                    , sub [] [ text "s" ]
                                    ]
                                , Select.select [ Select.id "gammaS" ]
                                    steelFactorsToSelect
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs4 ]
                                [ Form.label [ for "bending-moment" ]
                                    [ text "bending moment - M"
                                    , sub [] [ text "ed" ]
                                    ]
                                , Input.text [ Input.id "bending-moment" ]
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
            ]
    }


mapItemFromNumber : List number -> (number -> String) -> List (Select.Item msg)
mapItemFromNumber collection function =
    List.map
        (\item -> Select.item [ value (function item) ] [ text (function item) ])
        collection

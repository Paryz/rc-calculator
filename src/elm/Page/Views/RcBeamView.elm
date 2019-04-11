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
            List.map
                (\steelClass ->
                    if steelClass == 500 then
                        Select.item [ value (String.fromInt steelClass), selected True ]
                            [ text (String.fromInt steelClass) ]

                    else
                        Select.item [ value (String.fromInt steelClass) ]
                            [ text (String.fromInt steelClass) ]
                )
                Classes.steel

        concreteFactorsToSelect =
            mapItemFromFloat Factors.concrete

        steelFactorsToSelect =
            mapItemFromFloat Factors.steel

        reinforcementRequiredToString =
            let
                ( top, bottom ) =
                    model.reinforcement

                maximumReinforcement =
                    model.maximumReinforcement
            in
            if top < 0 || bottom < 0 || maximumReinforcement < Basics.toFloat (bottom + top) then
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
            ]
    }


mapItemFromFloat : List Float -> List (Select.Item msg)
mapItemFromFloat collection =
    List.map
        (\item -> Select.item [ value (String.fromFloat item) ] [ text (String.fromFloat item) ])
        collection

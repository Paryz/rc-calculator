module ColumnTest exposing (suite)

import Calculator.Column as Calculator
import Expect exposing (FloatingPointTolerance(..))
import Page.RcColumn.Types exposing (Column)
import Test exposing (Test, describe, test)


column : Column
column =
    { height = 400
    , width = 400
    , cover = 35
    , axialForce = 1200
    , bendingMoment = 120
    , concreteClass = 30
    , steelClass = 500
    , concreteFactor = 1.5
    , steelFactor = 1.15
    , alphaCC = 0.85
    , mainBarDiameter = 20
    , barsCount = 8
    }


suite : Test
suite =
    describe "Column calculator"
        [ test "minimum reinforcement ratio" <|
            \_ ->
                Calculator.minReinforcement (400 * 400)
                    |> Expect.equal 320
        , test "maximum reinforcement ratio" <|
            \_ ->
                Calculator.maxReinforcement (400 * 400)
                    |> Expect.equal 6400
        , test "minimum eccentricity" <|
            \_ ->
                Calculator.minimumEccentricity 400
                    |> Expect.within (Absolute 0.01) 20
        , test "effective design moment uses minimum eccentricity rule" <|
            \_ ->
                Calculator.effectiveDesignMoment 10 1200 400
                    |> Expect.within (Absolute 0.01) 24
        , test "provided reinforcement for 8x20" <|
            \_ ->
                Calculator.providedReinforcement 8 20
                    |> Expect.within (Absolute 0.01) 2513.27
        , test "required reinforcement is bounded by EC2 min and max limits" <|
            \_ ->
                let
                    required =
                        Calculator.calculateRequiredReinforcement column

                    minAs =
                        Calculator.minReinforcement (400 * 400)

                    maxAs =
                        Calculator.maxReinforcement (400 * 400)
                in
                Expect.equal True (required >= minAs && required <= maxAs)
        , test "higher moment increases required reinforcement" <|
            \_ ->
                let
                    required =
                        Calculator.calculateRequiredReinforcement column

                    highMomentRequired =
                        Calculator.calculateRequiredReinforcement { column | bendingMoment = 250 }
                in
                Expect.equal True (highMomentRequired > required)
        ]

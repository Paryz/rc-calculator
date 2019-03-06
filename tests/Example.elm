module Example exposing (suite)

import Calculator.Beam as Calculator
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Test exposing (..)


suite : Test
suite =
    describe "The Calculator module"
        [ describe "Calculator.fyd"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    1.15
                        |> Calculator.fYd 500.0
                        |> Expect.within (Absolute 0.01) 434.78
            ]
        ]

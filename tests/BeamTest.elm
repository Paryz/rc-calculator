module BeamTest exposing (suite)

import Calculator.Beam as Calculator
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Test exposing (..)


suite : Test
suite =
    describe "The Calculator module"
        [ describe "fYd"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    1.15
                        |> Calculator.fYd 500.0
                        |> Expect.within (Absolute 0.01) 434.78
            ]
        , describe "fCd"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    1.5
                        |> Calculator.fCd 1.0 30.0
                        |> Expect.within (Absolute 1) 20
            ]
        , describe "fCtm"
            -- Nest as many descriptions as you like.
            [ test "returns correct value for fCk lower then 50" <|
                \_ ->
                    30.0
                        |> Calculator.fCtm
                        |> Expect.within (Absolute 0.001) 2.896
            , test "returns correct value for fCk bigger then 50" <|
                \_ ->
                    55.0
                        |> Calculator.fCtm
                        |> Expect.within (Absolute 0.001) 4.214
            ]
        , describe "effectiveHeight"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    20.0
                        |> Calculator.effectiveHeight 600.0 30.0 10.0
                        |> Expect.within (Absolute 1) 550
            ]
        , describe "minReinforcement"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight 600.0 30.0 10.0 20.0
                    in
                    effectiveHeight
                        |> Calculator.minReinforcement 30.0 500.0 400.0
                        |> Expect.within (Absolute 0.001) 331.355
            ]
        ]

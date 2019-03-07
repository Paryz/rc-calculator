module BeamTest exposing (suite)

import BeamMock exposing (..)
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
                    gammaS
                        |> Calculator.fYd fyk
                        |> Expect.within (Absolute 0.01) 434.78
            ]
        , describe "fCd"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    gammaC
                        |> Calculator.fCd alphaCC fck
                        |> Expect.within (Absolute 1) 17
            ]
        , describe "fCtm"
            -- Nest as many descriptions as you like.
            [ test "returns correct value for fCk lower then 50" <|
                \_ ->
                    fck
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
                    mainBarDiameter
                        |> Calculator.effectiveHeight height cover linkDiameter
                        |> Expect.within (Absolute 1) 550
            ]
        , describe "minReinforcement"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight height cover linkDiameter mainBarDiameter

                        fCtm =
                            Calculator.fCtm fck
                    in
                    effectiveHeight
                        |> Calculator.minReinforcement fCtm fyk width
                        |> Expect.within (Absolute 0.001) 331.355
            ]
        , describe "sC"
            -- Nest as many descriptions as you like.
            [ test "returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight height cover linkDiameter mainBarDiameter

                        fCd =
                            Calculator.fCd alphaCC fck gammaC
                    in
                    effectiveHeight
                        |> Calculator.sC bendingMoment alpha fCd width
                        |> Expect.within (Absolute 0.01) 9.72e-8
            ]
        ]

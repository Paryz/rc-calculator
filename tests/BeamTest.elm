module BeamTest exposing (suite)

import BeamMock as Mock
import Calculator.Beam as Calculator
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Test exposing (..)


suite : Test
suite =
    describe "The Calculator module"
        [ describe "fYd"
            [ test "returns correct value" <|
                \_ ->
                    Mock.gammaS
                        |> Calculator.fYd Mock.fyk
                        |> Expect.within (Absolute 0.01) 434.78
            ]
        , describe "fCd"
            [ test "returns correct value" <|
                \_ ->
                    Mock.gammaC
                        |> Calculator.fCd Mock.alphaCC Mock.fck
                        |> Expect.within (Absolute 1) 17
            ]
        , describe "fCtm"
            [ test "returns correct value for fCk lower then 50" <|
                \_ ->
                    Mock.fck
                        |> Calculator.fCtm
                        |> Expect.within (Absolute 0.001) 2.896
            , test "returns correct value for fCk bigger then 50" <|
                \_ ->
                    55.0
                        |> Calculator.fCtm
                        |> Expect.within (Absolute 0.001) 4.214
            ]
        , describe "effectiveHeight"
            [ test "returns correct value" <|
                \_ ->
                    Mock.mainBarDiameter
                        |> Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter
                        |> Expect.within (Absolute 1) 550
            ]
        , describe "minReinforcement"
            [ test "returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter Mock.mainBarDiameter

                        fCtm =
                            Calculator.fCtm Mock.fck
                    in
                    effectiveHeight
                        |> Calculator.minReinforcement fCtm Mock.fyk Mock.width
                        |> Expect.within (Absolute 0.001) 331.355
            ]
        , describe "sC"
            [ test "returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter Mock.mainBarDiameter

                        fCd =
                            Calculator.fCd Mock.alphaCC Mock.fck Mock.gammaC
                    in
                    effectiveHeight
                        |> Calculator.sC Mock.bendingMoment Mock.alpha fCd Mock.width
                        |> Expect.within (Absolute 0.01) 0.097
            ]
        , describe "ksiEffective"
            [ test " returns correct value" <|
                \_ ->
                    let
                        effectiveHeight =
                            Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter Mock.mainBarDiameter

                        fCd =
                            Calculator.fCd Mock.alphaCC Mock.fck Mock.gammaC

                        sC =
                            Calculator.sC Mock.bendingMoment Mock.alpha fCd Mock.width effectiveHeight
                    in
                    sC
                        |> Calculator.ksiEffective
                        |> Expect.within (Absolute 0.001) 0.1024
            ]
        , describe "ksiEffectiveLim"
            [ test " returns correct value" <|
                \_ ->
                    let
                        fYd =
                            Calculator.fYd Mock.fyk Mock.gammaS
                    in
                    fYd
                        |> Calculator.ksiEffectiveLim
                        |> Expect.within (Absolute 0.001) 0.493
            ]
        , describe "reqReinforcement"
            [ test "single reinforced section" <|
                \_ ->
                    let
                        fCd =
                            Calculator.fCd Mock.alphaCC Mock.fck Mock.gammaC

                        fYd =
                            Calculator.fYd Mock.fyk Mock.gammaS

                        ksiEffectiveLim =
                            Calculator.ksiEffectiveLim fYd

                        effectiveHeight =
                            Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter Mock.mainBarDiameter

                        sC =
                            Calculator.sC Mock.bendingMoment Mock.alpha fCd Mock.width effectiveHeight

                        ksiEffective =
                            Calculator.ksiEffective sC
                    in
                    Mock.cover
                        |> Calculator.reqReinforcement ksiEffective ksiEffectiveLim Mock.alpha fCd Mock.width effectiveHeight fYd Mock.bendingMoment
                        |> Expect.equal ( 0, 882 )
            , test "doubly reinforced section" <|
                \_ ->
                    let
                        fCd =
                            Calculator.fCd Mock.alphaCC Mock.fck Mock.gammaC

                        fYd =
                            Calculator.fYd Mock.fyk Mock.gammaS

                        ksiEffectiveLim =
                            Calculator.ksiEffectiveLim fYd

                        effectiveHeight =
                            Calculator.effectiveHeight Mock.height Mock.cover Mock.linkDiameter Mock.mainBarDiameter

                        sC =
                            Calculator.sC Mock.bigBendingMoment Mock.alpha fCd Mock.width effectiveHeight

                        ksiEffective =
                            Calculator.ksiEffective sC
                    in
                    Mock.topCover
                        |> Calculator.reqReinforcement ksiEffective ksiEffectiveLim Mock.alpha fCd Mock.width effectiveHeight fYd Mock.bigBendingMoment
                        |> Expect.equal ( 1083, 5328 )
            ]
        , describe "maximumReinforcement"
            [ test "calculate correct value" <|
                \_ ->
                    Mock.width
                        |> Calculator.maximumReinforcement Mock.height
                        |> Expect.within (Absolute 0.001) 9600
            ]
        ]

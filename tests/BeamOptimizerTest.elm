module BeamOptimizerTest exposing (suite)

import Calculator.BeamOptimizer as Optimizer
import Expect
import Page.RcBeam.Types exposing (Beam)
import Test exposing (Test, describe, test)


beam : Beam
beam =
    { height = 600
    , width = 400
    , cover = 30
    , topCover = 30
    , concreteClass = 30
    , steelClass = 500
    , concreteFactor = 1.5
    , steelFactor = 1.15
    , alphaCC = 0.85
    , linkDiameter = 10
    , mainBarDiameter = 20
    , bendingMoment = 200
    }


suite : Test
suite =
    describe "Beam optimizer"
        [ test "returns feasible candidates for standard moment" <|
            \_ ->
                beam
                    |> Optimizer.optimize
                    |> List.isEmpty
                    |> Expect.equal False
        , test "solutions are sorted by objective" <|
            \_ ->
                let
                    objectives =
                        beam
                            |> Optimizer.optimize
                            |> List.map .objective
                in
                Expect.equal objectives (List.sort objectives)
        ]

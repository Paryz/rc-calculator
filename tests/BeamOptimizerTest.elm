module BeamOptimizerTest exposing (suite)

import Calculator.BeamOptimizer as Optimizer
import Expect
import Page.RcBeam.Types exposing (Beam, OptimizerLocks)
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
    let
        unlocked =
            { width = False
            , height = False
            , mainBarDiameter = False
            , stirrupDiameter = False
            }
    in
    describe "Beam optimizer"
        [ test "returns feasible candidates for standard moment" <|
            \_ ->
                beam
                    |> (\b -> Optimizer.optimize b unlocked)
                    |> List.isEmpty
                    |> Expect.equal False
        , test "solutions are sorted by objective" <|
            \_ ->
                let
                    objectives =
                        beam
                            |> (\b -> Optimizer.optimize b unlocked)
                            |> List.map .objective
                in
                Expect.equal objectives (List.sort objectives)
        , test "solutions include searched stirrup diameters" <|
            \_ ->
                let
                    stirrups =
                        beam
                            |> (\b -> Optimizer.optimize b unlocked)
                            |> List.map .stirrupDiameter
                in
                Expect.equal True (List.all (\v -> List.member v [ 6, 8, 10, 12, 16 ]) stirrups)
        , test "locked values constrain optimizer output" <|
            \_ ->
                let
                    locks : OptimizerLocks
                    locks =
                        { width = True
                        , height = True
                        , mainBarDiameter = True
                        , stirrupDiameter = True
                        }

                    solutions =
                        Optimizer.optimize beam locks
                in
                Expect.equal
                    True
                    (List.all
                        (\s ->
                            s.width
                                == round beam.width
                                && s.height
                                == round beam.height
                                && s.diameter
                                == round beam.mainBarDiameter
                                && s.stirrupDiameter
                                == round beam.linkDiameter
                        )
                        solutions
                    )
        ]

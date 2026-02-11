module Calculator.BeamOptimizer exposing (optimize)

import Calculator.Beam
import Page.RcBeam.Types exposing (Beam, OptimizationSolution)


optimize : Beam -> List OptimizationSolution
optimize baseBeam =
    let
        solutions =
            List.concatMap
                (\width ->
                    List.concatMap
                        (\height ->
                            List.map
                                (evaluateCandidate baseBeam width height)
                                candidateDiameters
                        )
                        candidateHeights
                )
                candidateWidths
                |> List.filterMap identity
    in
    solutions
        |> List.sortBy .objective
        |> List.take 12


candidateWidths : List Int
candidateWidths =
    rangeStep 250 650 25


candidateHeights : List Int
candidateHeights =
    rangeStep 350 1000 25


candidateDiameters : List Int
candidateDiameters =
    [ 12, 16, 20, 25, 32 ]


maxBarsPerLayer : Int
maxBarsPerLayer =
    10


evaluateCandidate : Beam -> Int -> Int -> Int -> Maybe OptimizationSolution
evaluateCandidate baseBeam width height diameter =
    let
        beam =
            { baseBeam
                | width = toFloat width
                , height = toFloat height
                , mainBarDiameter = toFloat diameter
            }

        ( topRequired, bottomRequired ) =
            Calculator.Beam.calculate beam

        requiredAs =
            max 0 topRequired + max 0 bottomRequired

        barArea =
            pi * toFloat diameter ^ 2 / 4

        topBars =
            barsForRequiredArea (max 0 topRequired) barArea

        bottomBars =
            barsForRequiredArea (max 0 bottomRequired) barArea

        providedAs =
            round (toFloat (topBars + bottomBars) * barArea)

        maxAs =
            Calculator.Beam.maximumReinforcement (toFloat height) (toFloat width)

        utilization =
            if providedAs <= 0 then
                0

            else
                toFloat requiredAs / toFloat providedAs

        objective =
            toFloat (width * height) + 8 * toFloat providedAs

        isFeasible =
            topRequired
                >= 0
                && bottomRequired
                >= 0
                && requiredAs
                > 0
                && providedAs
                >= requiredAs
                && topBars
                <= maxBarsPerLayer
                && bottomBars
                <= maxBarsPerLayer
                && toFloat providedAs
                <= maxAs
    in
    if isFeasible then
        Just
            { width = width
            , height = height
            , diameter = diameter
            , topBars = topBars
            , bottomBars = bottomBars
            , requiredAs = requiredAs
            , providedAs = providedAs
            , utilization = utilization
            , objective = objective
            }

    else
        Nothing


barsForRequiredArea : Int -> Float -> Int
barsForRequiredArea requiredArea barArea =
    if requiredArea <= 0 then
        2

    else
        max 2 (ceiling (toFloat requiredArea / barArea))


rangeStep : Int -> Int -> Int -> List Int
rangeStep start stop step =
    if start > stop then
        []

    else
        start :: rangeStep (start + step) stop step

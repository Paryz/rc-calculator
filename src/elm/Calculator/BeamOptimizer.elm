module Calculator.BeamOptimizer exposing (optimize)

import Calculator.Beam
import Page.RcBeam.Types exposing (Beam, OptimizationSolution, OptimizerLocks)


optimize : Beam -> OptimizerLocks -> List OptimizationSolution
optimize baseBeam optimizerLocks =
    let
        widths =
            if optimizerLocks.width then
                [ round baseBeam.width ]

            else
                candidateWidths

        heights =
            if optimizerLocks.height then
                [ round baseBeam.height ]

            else
                candidateHeights

        diameters =
            if optimizerLocks.mainBarDiameter then
                [ round baseBeam.mainBarDiameter ]

            else
                candidateDiameters

        stirrupDiameters =
            if optimizerLocks.stirrupDiameter then
                [ round baseBeam.linkDiameter ]

            else
                candidateStirrupDiameters

        solutions =
            List.concatMap
                (\width ->
                    List.concatMap
                        (\height ->
                            List.concatMap
                                (\stirrupDiameter ->
                                    List.map
                                        (evaluateCandidate baseBeam width height stirrupDiameter)
                                        diameters
                                )
                                stirrupDiameters
                        )
                        heights
                )
                widths
                |> List.filterMap identity
    in
    solutions
        |> List.sortBy .objective
        |> List.take 12


candidateWidths : List Int
candidateWidths =
    rangeStep 250 1500 25


candidateHeights : List Int
candidateHeights =
    rangeStep 350 1500 25


candidateDiameters : List Int
candidateDiameters =
    [ 12, 16, 20, 25, 32 ]


candidateStirrupDiameters : List Int
candidateStirrupDiameters =
    [ 6, 8, 10, 12, 16 ]


maxBarsPerLayer : Int
maxBarsPerLayer =
    10


evaluateCandidate : Beam -> Int -> Int -> Int -> Int -> Maybe OptimizationSolution
evaluateCandidate baseBeam width height stirrupDiameter diameter =
    let
        beam =
            { baseBeam
                | width = toFloat width
                , height = toFloat height
                , linkDiameter = toFloat stirrupDiameter
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
            , stirrupDiameter = stirrupDiameter
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

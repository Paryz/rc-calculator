module Calculator.Column exposing (calculateRequiredReinforcement, effectiveDesignMoment, fCd, fYd, maxReinforcement, minReinforcement, minimumEccentricity, providedReinforcement)

import Page.RcColumn.Types exposing (Column)


fYd : Float -> Float -> Float
fYd fYk gammaS =
    fYk / gammaS


fCd : Float -> Float -> Float -> Float
fCd alphaCC fCk gammaC =
    (alphaCC * fCk) / gammaC


grossArea : Float -> Float -> Float
grossArea height width =
    height * width


minReinforcement : Float -> Float
minReinforcement area =
    0.002 * area


maxReinforcement : Float -> Float
maxReinforcement area =
    0.04 * area


minimumEccentricity : Float -> Float
minimumEccentricity height =
    max 20 (height / 30)


effectiveDesignMoment : Float -> Float -> Float -> Float
effectiveDesignMoment bendingMoment axialForce height =
    let
        eMin =
            minimumEccentricity height

        mMin =
            (axialForce * eMin) / 1000
    in
    max bendingMoment mMin


calculateRequiredReinforcement : Column -> Float
calculateRequiredReinforcement column =
    let
        area =
            grossArea column.height column.width

        minAs =
            minReinforcement area

        maxAs =
            maxReinforcement area

        mEd =
            effectiveDesignMoment column.bendingMoment column.axialForce column.height
    in
    solveRequiredAs column minAs maxAs mEd


solveRequiredAs : Column -> Float -> Float -> Float -> Float
solveRequiredAs column minAs maxAs mEd =
    if checkCapacity column minAs mEd then
        minAs

    else if not (checkCapacity column maxAs mEd) then
        maxAs

    else
        bisectAs column mEd minAs maxAs 0


bisectAs : Column -> Float -> Float -> Float -> Int -> Float
bisectAs column mEd low high iteration =
    if iteration >= 40 || abs (high - low) < 0.1 then
        high

    else
        let
            mid =
                (low + high) / 2
        in
        if checkCapacity column mid mEd then
            bisectAs column mEd low mid (iteration + 1)

        else
            bisectAs column mEd mid high (iteration + 1)


checkCapacity : Column -> Float -> Float -> Bool
checkCapacity column asTotal mEd =
    let
        nEd =
            column.axialForce * 1000

        points =
            interactionPoints column asTotal
    in
    List.any (\( nRd, mRd ) -> nRd >= nEd && mRd >= mEd) points


interactionPoints : Column -> Float -> List ( Float, Float )
interactionPoints column asTotal =
    let
        steps =
            120

        xMax =
            max 1 (1.5 * column.height)

        stepSize =
            xMax / toFloat steps
    in
    List.range 1 steps
        |> List.map (\i -> sectionResistance column asTotal (toFloat i * stepSize))


sectionResistance : Column -> Float -> Float -> ( Float, Float )
sectionResistance column asTotal x =
    let
        fcd =
            fCd column.alphaCC column.concreteClass column.concreteFactor

        fyd =
            fYd column.steelClass column.steelFactor

        es =
            200000

        epsilonCu =
            0.0035

        b =
            column.width

        h =
            column.height

        dPrime =
            column.cover + (column.mainBarDiameter / 2)

        d =
            h - dPrime

        yMid =
            h / 2

        asLayer =
            asTotal / 2

        lambda =
            0.8

        eta =
            if column.concreteClass <= 50 then
                1

            else
                max 0.67 (1 - (column.concreteClass - 50) / 200)

        xBlock =
            min x h

        concreteForce =
            eta * fcd * b * lambda * xBlock

        concreteY =
            (lambda * xBlock) / 2

        steelStress y =
            let
                strain =
                    epsilonCu * (1 - (y / x))
            in
            clamp -fyd fyd (es * strain)

        fsTop =
            asLayer * steelStress dPrime

        fsBottom =
            asLayer * steelStress d

        nRd =
            concreteForce + fsTop + fsBottom

        mNmm =
            (concreteForce * (yMid - concreteY))
                + (fsTop * (yMid - dPrime))
                + (fsBottom * (yMid - d))
    in
    ( nRd, abs mNmm / 1000000 )


providedReinforcement : Int -> Float -> Float
providedReinforcement barsCount barDiameter =
    let
        barArea =
            pi * barDiameter ^ 2 / 4
    in
    toFloat barsCount * barArea

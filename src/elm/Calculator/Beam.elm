module Calculator.Beam exposing (effectiveHeight, fCd, fCtm, fYd, ksiEffective, ksiEffectiveLim, maximumReinforcement, minReinforcement, reqReinforcement, sC)

import Calculator.Types exposing (..)


fYd : Fyk -> GammaS -> Fyd
fYd fYk gammaS =
    fYk / gammaS


fCd : AlphaCC -> Fck -> GammaC -> Fcd
fCd alphaCC fCk gammaC =
    (alphaCC * fCk) / gammaC


fCtm : Fck -> Fctm
fCtm fCk =
    if fCk < 50 then
        0.3 * fCk ^ (2 / 3)

    else
        let
            fCm =
                fCk + 8.0

            ln =
                logBase e
        in
        2.12 * ln (1 + (fCm / 10))


effectiveHeight : Height -> Cover -> LinkDiameter -> MainBarDiameter -> EffectiveHeight
effectiveHeight height cover linkDiameter diameter =
    height - cover - linkDiameter - (diameter / 2)


minReinforcement : Fctm -> Fyk -> Width -> EffectiveHeight -> MinReinforcement
minReinforcement fCtmValue fYk width effectiveHeightValue =
    max (0.26 * (fCtmValue / fYk) * width * effectiveHeightValue) (0.0013 * width * effectiveHeightValue)


sC : BendingMoment -> Alpha -> Fcd -> Width -> EffectiveHeight -> Sc
sC bendingMoment alpha fcdValue width effectiveHeightValue =
    (bendingMoment * 1.0e6) / (alpha * fcdValue * width * effectiveHeightValue ^ 2)


ksiEffective : Sc -> KsiEffective
ksiEffective sCValue =
    1 - sqrt (1 - (2 * sCValue))


ksiEffectiveLim : Fyd -> KsiEffectiveLim
ksiEffectiveLim fYdValue =
    0.8 * (0.0035 / (0.0035 + (fYdValue / 200000)))


reqReinforcement : KsiEffective -> KsiEffectiveLim -> Alpha -> Fcd -> Width -> EffectiveHeight -> Fyd -> BendingMoment -> Cover -> ReqReinforcement
reqReinforcement ksiEffectiveValue ksiEffectiveLimValue alpha fCdValue width effectiveHeightValue fYdValue bendingMomentValue cover =
    let
        bottomReinforcementWithoutKsi =
            (alpha * fCdValue * width * effectiveHeightValue) / fYdValue
    in
    if ksiEffectiveValue <= ksiEffectiveLimValue then
        -- single reinforced section
        let
            bottomReinforcement =
                bottomReinforcementWithoutKsi * ksiEffectiveValue
        in
        ( 0, round bottomReinforcement )

    else
        -- doubly reinforced section
        let
            bottomReinforcementPrime =
                bottomReinforcementWithoutKsi * ksiEffectiveLimValue

            partialEquationForMomentPrime =
                effectiveHeightValue - 0.5 * (ksiEffectiveLimValue * effectiveHeightValue)

            bendingMomentPrime =
                0.000001 * (alpha * fCdValue * width * ksiEffectiveLimValue * effectiveHeightValue * partialEquationForMomentPrime)

            bendingMomentDelta =
                1000000 * (bendingMomentValue - bendingMomentPrime)

            topReinforcement =
                bendingMomentDelta / (fYdValue * (effectiveHeightValue - cover))

            bottomReinforcement =
                bottomReinforcementPrime + topReinforcement
        in
        ( round topReinforcement, round bottomReinforcement )


maximumReinforcement : Height -> Width -> MaximumReinforcement
maximumReinforcement height width =
    0.04 * height * width

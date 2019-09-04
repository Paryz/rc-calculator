module Calculator.Beam exposing (bendingMomentDelta, bendingMomentPrime, bottomReinforcement, calculate, effectiveHeight, fCd, fCtm, fYd, ksiEffective, ksiEffectiveLim, maximumReinforcement, minReinforcement, reqReinforcement, sC, topReinforcement)

import Calculator.Types exposing (Alpha, AlphaCC, BendingMoment, Cover, EffectiveHeight, Fcd, Fck, Fctm, Fyd, Fyk, GammaC, GammaS, Height, KsiEffective, KsiEffectiveLim, LinkDiameter, MainBarDiameter, MaximumReinforcement, MinReinforcement, ReqReinforcement, Sc, Width)
import Page.RcBeam.Types exposing (Beam)


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


bottomReinforcement : Alpha -> Fcd -> Width -> EffectiveHeight -> Float -> Fyd -> Float
bottomReinforcement alpha fCdValue width effectiveHeightValue ksi fYdValue =
    (alpha * fCdValue * width * ksi * effectiveHeightValue) / fYdValue


bendingMomentPrime : Fcd -> Alpha -> Width -> KsiEffectiveLim -> EffectiveHeight -> BendingMoment
bendingMomentPrime fCdValue alpha width ksiEffectiveLimValue effectiveHeightValue =
    0.000001 * (alpha * fCdValue * width * ksiEffectiveLimValue * effectiveHeightValue * (effectiveHeightValue - 0.5 * (ksiEffectiveLimValue * effectiveHeightValue)))


bendingMomentDelta : BendingMoment -> BendingMoment -> BendingMoment
bendingMomentDelta bendingMomentValue bendingMomentPrimeValue =
    bendingMomentValue - bendingMomentPrimeValue


topReinforcement : BendingMoment -> Fyd -> EffectiveHeight -> Cover -> Float
topReinforcement bendingMomentDeltaValue fYdValue effectiveHeightValue cover =
    bendingMomentDeltaValue / (fYdValue * (effectiveHeightValue - cover))


reqReinforcement : KsiEffective -> KsiEffectiveLim -> Alpha -> Fcd -> Width -> EffectiveHeight -> Fyd -> BendingMoment -> Cover -> MinReinforcement -> ReqReinforcement
reqReinforcement ksiEffectiveValue ksiEffectiveLimValue alpha fCdValue width effectiveHeightValue fYdValue bendingMomentValue topCover minReinforcementValue =
    if ksiEffectiveValue <= ksiEffectiveLimValue then
        -- single reinforced section
        let
            reinforcement =
                bottomReinforcement alpha fCdValue width effectiveHeightValue ksiEffectiveValue fYdValue

            bottomReinf =
                Basics.max reinforcement minReinforcementValue
        in
        ( 0, round bottomReinf )

    else
        -- doubly reinforced section
        let
            bottomReinforcementPrime =
                bottomReinforcement alpha fCdValue width effectiveHeightValue ksiEffectiveLimValue fYdValue

            bendingMomPrime =
                bendingMomentPrime fCdValue alpha width ksiEffectiveLimValue effectiveHeightValue

            bendingMomDelta =
                1000000 * bendingMomentDelta bendingMomentValue bendingMomPrime

            topReinfCals =
                topReinforcement bendingMomDelta fYdValue effectiveHeightValue topCover

            topReinf =
                Basics.max topReinfCals minReinforcementValue

            bottomReinf =
                Basics.max (bottomReinforcementPrime + topReinf) minReinforcementValue
        in
        ( round topReinf, round bottomReinf )


maximumReinforcement : Height -> Width -> MaximumReinforcement
maximumReinforcement height width =
    0.04 * height * width


calculate : Beam -> ReqReinforcement
calculate beam =
    let
        fyd =
            fYd beam.steelClass beam.steelFactor

        fcd =
            fCd 0.85 beam.concreteClass beam.concreteFactor

        fctm =
            fCtm beam.concreteClass

        effectiveHeightLocal =
            effectiveHeight beam.height beam.cover beam.linkDiameter beam.mainBarDiameter

        minReinforcementLocal =
            minReinforcement fctm beam.steelClass beam.width effectiveHeightLocal

        sc =
            sC beam.bendingMoment 1.0 fcd beam.width effectiveHeightLocal

        ksiEffectiveLocal =
            ksiEffective sc

        ksiEffectiveLimLocal =
            ksiEffectiveLim fyd
    in
    reqReinforcement ksiEffectiveLocal ksiEffectiveLimLocal 1.0 fcd beam.width effectiveHeightLocal fyd beam.bendingMoment beam.topCover minReinforcementLocal

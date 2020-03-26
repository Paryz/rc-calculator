module Page.RcBeam.Translator exposing (translate, withCalcs)

import Calculator.Beam as Calculator
import Page.RcBeam.Types exposing (Beam, StringedBeam, StringedResultBeam)
import Round


translate : StringedBeam -> Beam
translate stringedBeam =
    { height = maybeStringToFloat stringedBeam.height
    , width = maybeStringToFloat stringedBeam.width
    , cover = maybeStringToFloat stringedBeam.cover
    , topCover = maybeStringToFloat stringedBeam.topCover
    , linkDiameter = maybeStringToFloat stringedBeam.linkDiameter
    , mainBarDiameter = maybeStringToFloat stringedBeam.mainBarDiameter
    , steelClass = maybeStringToFloat stringedBeam.steelClass
    , steelFactor = maybeStringToFloat stringedBeam.steelFactor
    , concreteClass = maybeStringToFloat stringedBeam.concreteClass
    , concreteFactor = maybeStringToFloat stringedBeam.concreteFactor
    , alphaCC = maybeStringToFloat stringedBeam.alphaCC
    , bendingMoment = maybeStringToFloat stringedBeam.bendingMoment
    }


maybeStringToFloat : String -> Float
maybeStringToFloat string =
    Maybe.withDefault 0 (String.toFloat string)


withCalcs : StringedBeam -> StringedResultBeam
withCalcs stringedBeam =
    let
        beam =
            translate stringedBeam

        fcd =
            Calculator.fCd beam.alphaCC beam.concreteClass beam.concreteFactor

        fctm =
            Round.ceilingNum 1 (Calculator.fCtm beam.concreteClass)

        fyd =
            Calculator.fYd beam.steelClass beam.steelFactor

        effectiveHeight =
            Calculator.effectiveHeight beam.height beam.cover beam.linkDiameter beam.mainBarDiameter

        minReinforcement =
            Calculator.minReinforcement fctm beam.steelClass beam.width effectiveHeight

        sC =
            Calculator.sC beam.bendingMoment 1.0 fcd beam.width effectiveHeight

        ksiEffective =
            Calculator.ksiEffective sC

        ksiEffectiveLim =
            Calculator.ksiEffectiveLim fyd

        bottomReinforcementPrime =
            if ksiEffective < ksiEffectiveLim then
                Calculator.bottomReinforcement 1 fcd beam.width effectiveHeight ksiEffective fyd

            else
                Calculator.bottomReinforcement 1 fcd beam.width effectiveHeight ksiEffectiveLim fyd

        bendingMomentPrime =
            Calculator.bendingMomentPrime fcd 1 beam.width ksiEffectiveLim effectiveHeight

        bendingMomentDelta =
            Calculator.bendingMomentDelta beam.bendingMoment bendingMomentPrime

        ( topReqReinforcement, bottomReqReinforcement ) =
            Calculator.reqReinforcement ksiEffective ksiEffectiveLim 1.0 fcd beam.width effectiveHeight fyd beam.bendingMoment beam.cover minReinforcement

        maximumReinforcement =
            Calculator.maximumReinforcement beam.height beam.width
    in
    { height = stringedBeam.height
    , width = stringedBeam.width
    , cover = stringedBeam.cover
    , topCover = stringedBeam.topCover
    , concreteClass = stringedBeam.concreteClass
    , steelClass = stringedBeam.steelClass
    , concreteFactor = stringedBeam.concreteFactor
    , steelFactor = stringedBeam.steelFactor
    , alphaCC = stringedBeam.alphaCC
    , linkDiameter = stringedBeam.linkDiameter
    , mainBarDiameter = stringedBeam.mainBarDiameter
    , bendingMoment = stringedBeam.bendingMoment
    , fcd = Round.round 1 fcd
    , fctm = String.fromFloat fctm
    , fyd = Round.round 1 fyd
    , effectiveHeight = String.fromFloat effectiveHeight
    , minReinforcement = Round.round 1 minReinforcement
    , sC = Round.round 4 sC
    , ksiEffective = Round.round 4 ksiEffective
    , ksiEffectiveLim = Round.round 4 ksiEffectiveLim
    , bottomReinforcementPrime = Round.round 1 bottomReinforcementPrime
    , bendingMomentPrime = Round.round 1 bendingMomentPrime
    , bendingMomentDelta = Round.round 1 bendingMomentDelta
    , topReqReinforcement = Round.round 1 (toFloat topReqReinforcement)
    , bottomReqReinforcement = Round.round 1 (toFloat bottomReqReinforcement)
    , maximumReinforcement = Round.round 1 maximumReinforcement
    }

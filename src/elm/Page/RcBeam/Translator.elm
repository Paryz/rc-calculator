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
            Calculator.fCd 1.0 beam.concreteClass beam.concreteFactor

        fctm =
            Calculator.fCtm beam.concreteClass

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
    , linkDiameter = stringedBeam.linkDiameter
    , mainBarDiameter = stringedBeam.mainBarDiameter
    , bendingMoment = stringedBeam.bendingMoment
    , fcd = Round.round 2 fcd
    , fctm = Round.round 2 fctm
    , fyd = Round.round 2 fyd
    , effectiveHeight = Round.round 2 effectiveHeight
    , minReinforcement = Round.round 2 minReinforcement
    , sC = Round.round 2 sC
    , ksiEffective = Round.round 2 ksiEffective
    , ksiEffectiveLim = Round.round 2 ksiEffectiveLim
    , topReqReinforcement = Round.round 2 (toFloat topReqReinforcement)
    , bottomReqReinforcement = Round.round 2 (toFloat bottomReqReinforcement)
    , maximumReinforcement = Round.round 2 maximumReinforcement
    }

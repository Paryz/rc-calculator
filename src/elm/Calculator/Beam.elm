module Calculator.Beam exposing (effectiveHeight, fCd, fCtm, fYd, minReinforcement)

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

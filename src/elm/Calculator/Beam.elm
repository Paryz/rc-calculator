module Calculator.Beam exposing (effectiveHeight, fCd, fCtm, fYd, minReinforcement)


fYd : Float -> Float -> Float
fYd fYk gammaS =
    fYk / gammaS


fCd : Float -> Float -> Float -> Float
fCd alphaCC fCk gammaC =
    (alphaCC * fCk) / gammaC


fCtm : Float -> Float
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


effectiveHeight : Float -> Float -> Float -> Float -> Float
effectiveHeight height cover linkDiameter diameter =
    height - cover - linkDiameter - (diameter / 2)


minReinforcement : Float -> Float -> Float -> Float -> Float
minReinforcement fCk fYk width effectiveHeightValue =
    max (0.26 * (fCtm fCk / fYk) * width * effectiveHeightValue) (0.0013 * width * effectiveHeightValue)

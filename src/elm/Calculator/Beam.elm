module Calculator.Beam exposing (fCd, fCtm, fYd)


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

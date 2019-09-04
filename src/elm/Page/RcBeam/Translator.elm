module Page.RcBeam.Translator exposing (translate)

import Page.RcBeam.Types exposing (Beam, StringedBeam)


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

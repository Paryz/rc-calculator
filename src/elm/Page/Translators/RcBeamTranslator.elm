module Page.Translators.RcBeamTranslator exposing (Beam, StringedBeam, translate)


type alias StringedBeam =
    { height : String
    , width : String
    , cover : String
    , topCover : String
    , concreteClass : String
    , steelClass : String
    , concreteFactor : String
    , steelFactor : String
    , linkDiameter : String
    , mainBarDiameter : String
    , bendingMoment : String
    }


type alias Beam =
    { height : Float
    , width : Float
    , cover : Float
    , topCover : Float
    , concreteClass : Float
    , steelClass : Float
    , concreteFactor : Float
    , steelFactor : Float
    , linkDiameter : Float
    , mainBarDiameter : Float
    , bendingMoment : Float
    }


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

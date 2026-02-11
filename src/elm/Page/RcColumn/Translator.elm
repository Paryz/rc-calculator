module Page.RcColumn.Translator exposing (translate)

import Page.RcColumn.Types exposing (Column, StringedColumn)


translate : StringedColumn -> Column
translate stringedColumn =
    { height = maybeStringToFloat stringedColumn.height
    , width = maybeStringToFloat stringedColumn.width
    , cover = maybeStringToFloat stringedColumn.cover
    , axialForce = maybeStringToFloat stringedColumn.axialForce
    , bendingMoment = maybeStringToFloat stringedColumn.bendingMoment
    , concreteClass = maybeStringToFloat stringedColumn.concreteClass
    , steelClass = maybeStringToFloat stringedColumn.steelClass
    , concreteFactor = maybeStringToFloat stringedColumn.concreteFactor
    , steelFactor = maybeStringToFloat stringedColumn.steelFactor
    , alphaCC = maybeStringToFloat stringedColumn.alphaCC
    , mainBarDiameter = maybeStringToFloat stringedColumn.mainBarDiameter
    , barsCount = maybeStringToInt stringedColumn.barsCount
    }


maybeStringToFloat : String -> Float
maybeStringToFloat string =
    Maybe.withDefault 0 (String.toFloat string)


maybeStringToInt : String -> Int
maybeStringToInt string =
    Maybe.withDefault 0 (String.toInt string)

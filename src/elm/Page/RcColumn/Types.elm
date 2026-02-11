module Page.RcColumn.Types exposing (Column, Field(..), Model, Msg(..), StringedColumn)

import Session exposing (Session)


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    , column : StringedColumn
    , requiredReinforcement : Float
    , providedReinforcement : Float
    , minimumReinforcement : Float
    , maximumReinforcement : Float
    , effectiveMoment : Float
    , minimumEccentricity : Float
    , utilization : Float
    }


type Field
    = Height
    | Width
    | Cover
    | AxialForce
    | BendingMoment
    | ConcreteClass
    | SteelClass
    | ConcreteFactor
    | SteelFactor
    | AlphaCC
    | MainBarDiameter
    | BarsCount


type Msg
    = Update Field String


type alias StringedColumn =
    { height : String
    , width : String
    , cover : String
    , axialForce : String
    , bendingMoment : String
    , concreteClass : String
    , steelClass : String
    , concreteFactor : String
    , steelFactor : String
    , alphaCC : String
    , mainBarDiameter : String
    , barsCount : String
    }


type alias Column =
    { height : Float
    , width : Float
    , cover : Float
    , axialForce : Float
    , bendingMoment : Float
    , concreteClass : Float
    , steelClass : Float
    , concreteFactor : Float
    , steelFactor : Float
    , alphaCC : Float
    , mainBarDiameter : Float
    , barsCount : Int
    }

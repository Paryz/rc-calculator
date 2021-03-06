module Page.RcBeam.Types exposing (Beam, Field(..), Model, Msg(..), StringedBeam, StringedResultBeam)

import Calculator.Types
import Session exposing (Session)


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    , beam : StringedBeam
    , reinforcement : Calculator.Types.ReqReinforcement
    , minimumReinforcement : Calculator.Types.MinReinforcement
    , maximumReinforcement : Calculator.Types.MaximumReinforcement
    }


type Field
    = Height
    | Width
    | Cover
    | BendingMoment
    | ConcreteClass
    | SteelClass
    | ConcreteFactor
    | SteelFactor
    | AlphaCC
    | LinkBarDiameter
    | MainBarDiameter


type Msg
    = Update Field String


type alias StringedBeam =
    { height : String
    , width : String
    , cover : String
    , topCover : String
    , concreteClass : String
    , steelClass : String
    , concreteFactor : String
    , steelFactor : String
    , alphaCC : String
    , linkDiameter : String
    , mainBarDiameter : String
    , bendingMoment : String
    }


type alias StringedResultBeam =
    { height : String
    , width : String
    , cover : String
    , topCover : String
    , concreteClass : String
    , steelClass : String
    , concreteFactor : String
    , steelFactor : String
    , alphaCC : String
    , linkDiameter : String
    , mainBarDiameter : String
    , bendingMoment : String
    , fcd : String
    , fctm : String
    , fyd : String
    , effectiveHeight : String
    , minReinforcement : String
    , sC : String
    , ksiEffective : String
    , ksiEffectiveLim : String
    , bottomReinforcementPrime : String
    , bendingMomentPrime : String
    , bendingMomentDelta : String
    , topReqReinforcement : String
    , bottomReqReinforcement : String
    , maximumReinforcement : String
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
    , alphaCC : Float
    , linkDiameter : Float
    , mainBarDiameter : Float
    , bendingMoment : Float
    }

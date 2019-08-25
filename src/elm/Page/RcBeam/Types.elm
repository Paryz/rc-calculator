module Page.RcBeam.Types exposing (Beam, Field(..), Model, Msg(..), StringedBeam)

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
    | LinkBarDiameter
    | MainBarDiameter


type Msg
    = Update Field String
    | SendToJs StringedBeam


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

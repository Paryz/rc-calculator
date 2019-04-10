module Page.RcBeam exposing (Model, Msg(..), init, subscriptions, toSession, update)

import Calculator.Beam as Beam
import Calculator.Types as Types
import Session exposing (Session)



-- MODEL


type alias Beam =
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
    , reinforcementRequired : ( Int, Int )
    }


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    , beam : Beam
    }


type Msg
    = UpdateHeight String


init : Session -> ( Model, Cmd Msg )
init session =
    let
        beam =
            { height = "600"
            , width = "400"
            , cover = "30"
            , topCover = "50"
            , concreteClass = "30"
            , steelClass = "500"
            , concreteFactor = "1.5"
            , steelFactor = "1.15"
            , linkDiameter = "10.0"
            , mainBarDiameter = "20.0"
            , bendingMoment = "200.0"
            , reinforcementRequired = ( 0, 0 )
            }
    in
    ( { session = session
      , pageTitle = "Rc Beam"
      , pageBody = "This is the rc-beam page"
      , beam = { beam | reinforcementRequired = calculateReinforcement beam }
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        beam =
            model.beam
    in
    case msg of
        UpdateHeight newHeight ->
            let
                updatedBeam =
                    { beam | height = newHeight }

                reqReinforcement =
                    calculateReinforcement updatedBeam

                newBeam =
                    { updatedBeam | reinforcementRequired = reqReinforcement }
            in
            ( { model | beam = newBeam }, Cmd.none )


calculateReinforcement : Beam -> Types.ReqReinforcement
calculateReinforcement beam =
    let
        height =
            maybeStringToFloat beam.height

        width =
            maybeStringToFloat beam.width

        cover =
            maybeStringToFloat beam.cover

        topCover =
            maybeStringToFloat beam.topCover

        linkDiameter =
            maybeStringToFloat beam.linkDiameter

        mainBarDiameter =
            maybeStringToFloat beam.mainBarDiameter

        steelClass =
            maybeStringToFloat beam.steelClass

        steelFactor =
            maybeStringToFloat beam.steelFactor

        concreteClass =
            maybeStringToFloat beam.concreteClass

        concreteFactor =
            maybeStringToFloat beam.concreteFactor

        bendingMoment =
            maybeStringToFloat beam.bendingMoment

        fyd =
            Beam.fYd steelClass steelFactor

        fcd =
            Beam.fCd 0.85 concreteClass concreteFactor

        fctm =
            Beam.fCtm concreteFactor

        effectiveHeight =
            Beam.effectiveHeight height cover linkDiameter mainBarDiameter

        minReinforcement =
            Beam.minReinforcement fctm steelClass width effectiveHeight

        sc =
            Beam.sC bendingMoment 1.0 fcd width effectiveHeight

        ksiEffective =
            Beam.ksiEffective sc

        ksiEffectiveLim =
            Beam.ksiEffectiveLim fyd
    in
    Beam.reqReinforcement ksiEffective ksiEffectiveLim 1.0 fcd width effectiveHeight fyd bendingMoment topCover


maybeStringToFloat : String -> Float
maybeStringToFloat string =
    Maybe.withDefault 0 (String.toFloat string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

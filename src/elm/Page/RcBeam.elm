module Page.RcBeam exposing (Field(..), Model, Msg(..), init, subscriptions, toSession, update)

import Calculator.Beam as Beam
import Calculator.Types as Types
import Page.Translators.RcBeamTranslator as RcBeamTranslator exposing (Beam, StringedBeam)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    , beam : StringedBeam
    , reinforcement : Types.ReqReinforcement
    , minimumReinforcement : Types.MinReinforcement
    , maximumReinforcement : Types.MaximumReinforcement
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
    | LinBarDiameter
    | MainBarDiameter


type Msg
    = Update Field String


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
            }
    in
    ( { session = session
      , pageTitle = "Rc Beam"
      , pageBody = "This is the rc-beam page"
      , beam = beam
      , reinforcement = calculateReinforcement beam
      , minimumReinforcement = 331.355
      , maximumReinforcement = 9600.0
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
        Update field newValue ->
            let
                updatedBeam =
                    case field of
                        Height ->
                            { beam | height = newValue }

                        Width ->
                            { beam | width = newValue }

                        Cover ->
                            { beam | cover = newValue }

                        BendingMoment ->
                            { beam | bendingMoment = newValue }

                        ConcreteClass ->
                            { beam | concreteClass = newValue }

                        SteelClass ->
                            { beam | steelClass = newValue }

                        ConcreteFactor ->
                            { beam | concreteFactor = newValue }

                        SteelFactor ->
                            { beam | steelFactor = newValue }

                        MainBarDiameter ->
                            { beam | mainBarDiameter = newValue }

                        LinBarDiameter ->
                            { beam | linkDiameter = newValue }

                reqReinforcement =
                    calculateReinforcement updatedBeam

                maximumReinforcement =
                    calculateMaximumReinforcement updatedBeam

                minimumReinforcement =
                    calculateMinimumReinforcement updatedBeam
            in
            ( { model | beam = updatedBeam, reinforcement = reqReinforcement, maximumReinforcement = maximumReinforcement, minimumReinforcement = minimumReinforcement }, Cmd.none )


calculateReinforcement : StringedBeam -> Types.ReqReinforcement
calculateReinforcement stringedBeam =
    let
        beam =
            RcBeamTranslator.translate stringedBeam

        fyd =
            Beam.fYd beam.steelClass beam.steelFactor

        fcd =
            Beam.fCd 0.85 beam.concreteClass beam.concreteFactor

        fctm =
            Beam.fCtm beam.concreteClass

        effectiveHeight =
            Beam.effectiveHeight beam.height beam.cover beam.linkDiameter beam.mainBarDiameter

        minReinforcement =
            Beam.minReinforcement fctm beam.steelClass beam.width effectiveHeight

        sc =
            Beam.sC beam.bendingMoment 1.0 fcd beam.width effectiveHeight

        ksiEffective =
            Beam.ksiEffective sc

        ksiEffectiveLim =
            Beam.ksiEffectiveLim fyd
    in
    Beam.reqReinforcement ksiEffective ksiEffectiveLim 1.0 fcd beam.width effectiveHeight fyd beam.bendingMoment beam.topCover minReinforcement


calculateMaximumReinforcement : StringedBeam -> Types.MaximumReinforcement
calculateMaximumReinforcement stringedBeam =
    let
        beam =
            RcBeamTranslator.translate stringedBeam
    in
    Beam.maximumReinforcement beam.height beam.width


calculateMinimumReinforcement : StringedBeam -> Types.MinReinforcement
calculateMinimumReinforcement stringedBeam =
    let
        beam =
            RcBeamTranslator.translate stringedBeam

        effectiveHeight =
            Beam.effectiveHeight beam.height beam.cover beam.linkDiameter beam.mainBarDiameter

        fctm =
            Beam.fCtm beam.concreteClass
    in
    Beam.minReinforcement fctm beam.steelClass beam.width effectiveHeight



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

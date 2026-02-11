port module Page.RcBeam exposing (init, subscriptions, toSession, update, view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Beam
import Calculator.BeamOptimizer as BeamOptimizer
import Calculator.Types as Types
import Html exposing (Html, a, div, strong, text)
import Html.Attributes exposing (class, href, target)
import Page.RcBeam.Partials.BeamDrawing as BeamDrawing
import Page.RcBeam.Partials.Form as Form
import Page.RcBeam.Partials.Optimizer as Optimizer
import Page.RcBeam.Partials.Results as Results
import Page.RcBeam.Partials.Tables as Tables
import Page.RcBeam.Translator as Translator
import Page.RcBeam.Types exposing (Field(..), LockField(..), Model, Msg(..), OptimizerLocks, StringedBeam, StringedResultBeam)
import Session exposing (Session)



-- MODEL


init : Session -> ( Model, Cmd Msg )
init session =
    let
        beam =
            StringedBeam "600" "400" "30" "30" "30" "500" "1.5" "1.15" "0.85" "10" "20" "200"
    in
    ( { session = session
      , pageTitle = "Rc Beam"
      , pageBody = "This is the rc-beam page"
      , beam = beam
      , optimizerLocks =
            { width = False
            , height = False
            , mainBarDiameter = False
            , stirrupDiameter = False
            }
      , reinforcement = calculateReinforcement beam
      , minimumReinforcement = 331.355
      , maximumReinforcement = 9600.0
      }
    , toJs <| Translator.withCalcs beam
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
                newBeam =
                    updateBeam beam field newValue

                reqReinforcement =
                    calculateReinforcement newBeam

                maximumReinforcement =
                    calculateMaximumReinforcement newBeam

                minimumReinforcement =
                    calculateMinimumReinforcement newBeam
            in
            ( { model
                | beam = newBeam
                , reinforcement = reqReinforcement
                , maximumReinforcement = maximumReinforcement
                , minimumReinforcement = minimumReinforcement
              }
            , toJs <| Translator.withCalcs newBeam
            )

        ToggleOptimizerLock lockField isLocked ->
            ( { model | optimizerLocks = updateOptimizerLocks model.optimizerLocks lockField isLocked }
            , Cmd.none
            )


updateBeam : StringedBeam -> Field -> String -> StringedBeam
updateBeam beam field value =
    case field of
        Height ->
            { beam | height = value }

        Width ->
            { beam | width = value }

        Cover ->
            { beam | cover = value }

        BendingMoment ->
            { beam | bendingMoment = value }

        ConcreteClass ->
            { beam | concreteClass = value }

        SteelClass ->
            { beam | steelClass = value }

        ConcreteFactor ->
            { beam | concreteFactor = value }

        SteelFactor ->
            { beam | steelFactor = value }

        AlphaCC ->
            { beam | alphaCC = value }

        MainBarDiameter ->
            { beam | mainBarDiameter = value }

        LinkBarDiameter ->
            { beam | linkDiameter = value }


updateOptimizerLocks : OptimizerLocks -> LockField -> Bool -> OptimizerLocks
updateOptimizerLocks locks lockField isLocked =
    case lockField of
        LockWidth ->
            { locks | width = isLocked }

        LockHeight ->
            { locks | height = isLocked }

        LockMainBarDiameter ->
            { locks | mainBarDiameter = isLocked }

        LockStirrupDiameter ->
            { locks | stirrupDiameter = isLocked }


calculateReinforcement : StringedBeam -> Types.ReqReinforcement
calculateReinforcement stringedBeam =
    stringedBeam
        |> Translator.translate
        |> Calculator.Beam.calculate


calculateMaximumReinforcement : StringedBeam -> Types.MaximumReinforcement
calculateMaximumReinforcement stringedBeam =
    let
        beam =
            Translator.translate stringedBeam
    in
    Calculator.Beam.maximumReinforcement beam.height beam.width


calculateMinimumReinforcement : StringedBeam -> Types.MinReinforcement
calculateMinimumReinforcement stringedBeam =
    let
        beam =
            Translator.translate stringedBeam

        effectiveHeight =
            Calculator.Beam.effectiveHeight beam.height beam.cover beam.linkDiameter beam.mainBarDiameter

        fctm =
            Calculator.Beam.fCtm beam.concreteClass
    in
    Calculator.Beam.minReinforcement fctm beam.steelClass beam.width effectiveHeight



-- SUBSCRIPTIONS


port toJs : StringedResultBeam -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    let
        ( top, bottom ) =
            model.reinforcement

        totalReqReinforcement =
            Basics.toFloat <| bottom + top

        reinforcementRequiredToString =
            let
                maximumReinforcement =
                    model.maximumReinforcement
            in
            if top < 0 || bottom < 0 || maximumReinforcement < totalReqReinforcement then
                "Please provide bigger section"

            else
                "Top Reinforcement = " ++ String.fromInt top ++ ", Bottom Reinforcement = " ++ String.fromInt bottom

        optimizationSolutions =
            BeamOptimizer.optimize (Translator.translate model.beam) model.optimizerLocks
    in
    { title = model.pageTitle
    , content =
        Grid.container [ class "rc-beam-page" ]
            [ Grid.row []
                [ Grid.col [ Col.lg12, Col.xl9 ]
                    [ Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.middleXs, Col.lg12, Col.xl6 ]
                            [ Form.render model.beam model.optimizerLocks
                            ]
                        , Grid.col [ Col.middleXs, Col.lg12, Col.xl6, Col.attrs [ class "drawing" ] ]
                            [ BeamDrawing.render model.beam model.reinforcement ]
                        ]
                    , Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.xs12 ]
                            [ div []
                                [ strong []
                                    [ text reinforcementRequiredToString ]
                                ]
                            ]
                        ]
                    , Grid.row [ Row.centerMd ]
                        (Tables.render top bottom)
                    , Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.xs12 ]
                            [ Optimizer.render optimizationSolutions ]
                        ]
                    , Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.xs12 ]
                            [ a
                                [ href <| generatePdfUrl <| Translator.withCalcs model.beam
                                , target "_blank"
                                , class "btn btn-secondary"
                                ]
                                [ text "Print results" ]
                            ]
                        ]
                    ]
                , Grid.col [ Col.lg12, Col.xl3 ]
                    [ Grid.row [ Row.centerMd ] [ Results.template ] ]
                ]
            ]
    }


generatePdfUrl : StringedResultBeam -> String
generatePdfUrl beamResults =
    String.concat
        [ baseUrlWithFunction
        , "height="
        , beamResults.height
        , "&width="
        , beamResults.width
        , "&cover="
        , beamResults.cover
        , "&topCover="
        , beamResults.topCover
        , "&concreteClass="
        , beamResults.concreteClass
        , "&steelClass="
        , beamResults.steelClass
        , "&concreteFactor="
        , beamResults.concreteFactor
        , "&steelFactor="
        , beamResults.steelFactor
        , "&alphaCC="
        , beamResults.alphaCC
        , "&linkDiameter="
        , beamResults.linkDiameter
        , "&mainBarDiameter="
        , beamResults.mainBarDiameter
        , "&bendingMoment="
        , beamResults.bendingMoment
        , "&fcd="
        , beamResults.fcd
        , "&fctm="
        , beamResults.fctm
        , "&fyd="
        , beamResults.fyd
        , "&effectiveHeight="
        , beamResults.effectiveHeight
        , "&minReinforcement="
        , beamResults.minReinforcement
        , "&sC="
        , beamResults.sC
        , "&ksiEffective="
        , beamResults.ksiEffective
        , "&ksiEffectiveLim="
        , beamResults.ksiEffectiveLim
        , "&bottomReinforcementPrime="
        , beamResults.bottomReinforcementPrime
        , "&bendingMomentPrime="
        , beamResults.bendingMomentPrime
        , "&bendingMomentDelta="
        , beamResults.bendingMomentDelta
        , "&topReqReinforcement="
        , beamResults.topReqReinforcement
        , "&bottomReqReinforcement="
        , beamResults.bottomReqReinforcement
        , "&maximumReinforcement="
        , beamResults.maximumReinforcement
        ]


baseUrlWithFunction : String
baseUrlWithFunction =
    "https://rc-calculator-backend.herokuapp.com/api/renderpdf?"

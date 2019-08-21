module Page.RcBeam exposing (init, subscriptions, toSession, update, view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Beam
import Calculator.Types as Types
import Html exposing (Html, div, text)
import Page.RcBeam.Partials.BeamDrawing as BeamDrawing
import Page.RcBeam.Partials.Form as Form
import Page.RcBeam.Partials.Tables as Tables
import Page.RcBeam.Translator as Translator
import Page.RcBeam.Types exposing (Field(..), Model, Msg(..), StringedBeam)
import Session exposing (Session)



-- MODEL


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

                        LinkBarDiameter ->
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
    in
    { title = model.pageTitle
    , content =
        Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.middleXs, Col.lg12, Col.xl6 ]
                    [ Form.render model.beam ]
                , Grid.col [ Col.middleXs, Col.lg12, Col.xl6 ]
                    [ BeamDrawing.render model.beam model.reinforcement ]
                ]
            , Grid.row [ Row.centerMd ]
                [ Grid.col [ Col.xs12 ]
                    [ div [] [ text reinforcementRequiredToString ] ]
                ]
            , Grid.row [ Row.centerMd ]
                (Tables.render top bottom)
            ]
    }

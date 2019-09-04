port module Page.RcBeam exposing (init, subscriptions, toSession, update, view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Beam
import Calculator.Types as Types
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Page.RcBeam.Partials.BeamDrawing as BeamDrawing
import Page.RcBeam.Partials.Form as Form
import Page.RcBeam.Partials.Results as Results
import Page.RcBeam.Partials.Tables as Tables
import Page.RcBeam.Translator as Translator
import Page.RcBeam.Types exposing (Field(..), Model, Msg(..), StringedBeam, StringedResultBeam)
import Session exposing (Session)



-- MODEL


init : Session -> ( Model, Cmd Msg )
init session =
    let
        beam =
            StringedBeam "600" "400" "30" "30" "30" "500" "1.5" "1.15" "10.0" "20.0" "200"
    in
    ( { session = session
      , pageTitle = "Rc Beam"
      , pageBody = "This is the rc-beam page"
      , beam = beam
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
        SendToJs stringedBeam ->
            ( model, toJs <| Translator.withCalcs stringedBeam )

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
            ( { model | beam = newBeam, reinforcement = reqReinforcement, maximumReinforcement = maximumReinforcement, minimumReinforcement = minimumReinforcement }, toJs <| Translator.withCalcs newBeam )


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

        MainBarDiameter ->
            { beam | mainBarDiameter = value }

        LinkBarDiameter ->
            { beam | linkDiameter = value }


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
subscriptions model =
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
                [ Grid.col [ Col.lg12, Col.xl9 ]
                    [ Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.middleXs, Col.lg12, Col.xl6 ]
                            [ Form.render model.beam ]
                        , Grid.col [ Col.middleXs, Col.lg12, Col.xl6, Col.attrs [ class "drawing" ] ]
                            [ BeamDrawing.render model.beam model.reinforcement ]
                        ]
                    , Grid.row [ Row.centerMd ]
                        (Tables.render top bottom)
                    , Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.xs12 ]
                            [ div [] [ text reinforcementRequiredToString ] ]
                        ]
                    ]
                , Grid.col [ Col.lg12, Col.xl3 ]
                    [ Grid.row [ Row.centerMd ] [ Results.template model.beam ] ]
                ]
            ]
    }

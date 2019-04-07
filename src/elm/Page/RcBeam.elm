module Page.RcBeam exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Beam as Beam
import Calculator.Classes as Classes
import Calculator.Factors as Factors
import Calculator.Types as Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
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



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    let
        gamma =
            String.fromChar (Char.fromCode 947)

        concreteClassesToSelect =
            List.map
                (\( cube, cylinder ) -> Select.item [ value (String.fromInt cube) ] [ text (String.fromInt cube ++ "/" ++ String.fromInt cylinder) ])
                Classes.concrete

        steelClassesToSelect =
            List.map
                (\item -> Select.item [ value (String.fromInt item) ] [ text (String.fromInt item) ])
                Classes.steel

        concreteFactorsToSelect =
            List.map
                (\item -> Select.item [ value (String.fromFloat item) ] [ text (String.fromFloat item) ])
                Factors.concrete

        steelFactorsToSelect =
            List.map
                (\item -> Select.item [ value (String.fromFloat item) ] [ text (String.fromFloat item) ])
                Factors.steel

        reinforcementRequiredToString =
            let
                ( top, bottom ) =
                    model.beam.reinforcementRequired
            in
            String.fromInt top ++ " " ++ String.fromInt bottom
    in
    { title = model.pageTitle
    , content =
        Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.middleXs, Col.xs8 ]
                    [ Form.form []
                        [ Form.row []
                            [ Form.col [ Col.xs4 ]
                                [ Form.label [ for "height" ] [ text "height - h (mm)" ]
                                , Input.text
                                    [ Input.id "width"
                                    , Input.onInput (\height -> UpdateHeight height)
                                    , Input.value model.beam.height
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                                , Input.text
                                    [ Input.id "width"
                                    , Input.onInput (\width -> UpdateHeight width)
                                    , Input.value model.beam.width
                                    ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "cover" ]
                                    [ text "cover - c"
                                    , sub [] [ text "nom" ]
                                    , text " (mm)"
                                    ]
                                , Input.text [ Input.id "width" ]
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs3 ]
                                [ Form.label [ for "concrete-class" ]
                                    [ text "concrete class (MPa)" ]
                                , Select.select [ Select.id "concrete-class" ]
                                    concreteClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "steel-class" ]
                                    [ text "steel class (MPa)" ]
                                , Select.select [ Select.id "steel-class" ]
                                    steelClassesToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaC" ]
                                    [ text "concrete - "
                                    , text gamma
                                    , sub [] [ text "c" ]
                                    ]
                                , Select.select [ Select.id "gammaC" ]
                                    concreteFactorsToSelect
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaS" ]
                                    [ text "steel - "
                                    , text gamma
                                    , sub [] [ text "s" ]
                                    ]
                                , Select.select [ Select.id "gammaS" ]
                                    steelFactorsToSelect
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs4 ]
                                [ Form.label [ for "bending-moment" ]
                                    [ text "bending moment - M"
                                    , sub [] [ text "ed" ]
                                    ]
                                , Input.text [ Input.id "bending-moment" ]
                                ]
                            ]
                        , Form.row []
                            [ Form.col [ Col.xs12 ]
                                [ Form.label [ for "result" ] [ text "result - (mm)" ]
                                , Input.text
                                    [ Input.id "result"
                                    , Input.disabled True
                                    , Input.value reinforcementRequiredToString
                                    ]
                                ]
                            ]
                        ]
                    ]
                , Grid.col [ Col.middleXs, Col.xs4 ]
                    [ h1 [] [ text "test" ] ]
                ]
            ]
    }



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

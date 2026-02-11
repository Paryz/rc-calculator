module Page.RcColumn exposing (init, subscriptions, toSession, update, view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Calculator.Column as Calculator
import Html exposing (Html)
import Html.Attributes exposing (class)
import Page.RcColumn.Partials.ColumnDrawing as ColumnDrawing
import Page.RcColumn.Partials.Form as Form
import Page.RcColumn.Partials.Results as Results
import Page.RcColumn.Partials.Tables as Tables
import Page.RcColumn.Translator as Translator
import Page.RcColumn.Types exposing (Field(..), Model, Msg(..), StringedColumn)
import Session exposing (Session)


init : Session -> ( Model, Cmd Msg )
init session =
    let
        column =
            StringedColumn "400" "400" "35" "1200" "120" "30" "500" "1.5" "1.15" "0.85" "20" "8"

        calculated =
            calculate column
    in
    ( { session = session
      , pageTitle = "Rc Column"
      , pageBody = "Preliminary reinforced concrete column design"
      , column = column
      , requiredReinforcement = calculated.requiredReinforcement
      , providedReinforcement = calculated.providedReinforcement
      , minimumReinforcement = calculated.minimumReinforcement
      , maximumReinforcement = calculated.maximumReinforcement
      , effectiveMoment = calculated.effectiveMoment
      , minimumEccentricity = calculated.minimumEccentricity
      , utilization = calculated.utilization
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update field newValue ->
            let
                newColumn =
                    updateColumn model.column field newValue

                calculated =
                    calculate newColumn
            in
            ( { model
                | column = newColumn
                , requiredReinforcement = calculated.requiredReinforcement
                , providedReinforcement = calculated.providedReinforcement
                , minimumReinforcement = calculated.minimumReinforcement
                , maximumReinforcement = calculated.maximumReinforcement
                , effectiveMoment = calculated.effectiveMoment
                , minimumEccentricity = calculated.minimumEccentricity
                , utilization = calculated.utilization
              }
            , Cmd.none
            )


updateColumn : StringedColumn -> Field -> String -> StringedColumn
updateColumn column field value =
    case field of
        Height ->
            { column | height = value }

        Width ->
            { column | width = value }

        Cover ->
            { column | cover = value }

        AxialForce ->
            { column | axialForce = value }

        BendingMoment ->
            { column | bendingMoment = value }

        ConcreteClass ->
            { column | concreteClass = value }

        SteelClass ->
            { column | steelClass = value }

        ConcreteFactor ->
            { column | concreteFactor = value }

        SteelFactor ->
            { column | steelFactor = value }

        AlphaCC ->
            { column | alphaCC = value }

        MainBarDiameter ->
            { column | mainBarDiameter = value }

        BarsCount ->
            { column | barsCount = value }


type alias Calculation =
    { requiredReinforcement : Float
    , providedReinforcement : Float
    , minimumReinforcement : Float
    , maximumReinforcement : Float
    , effectiveMoment : Float
    , minimumEccentricity : Float
    , utilization : Float
    }


calculate : StringedColumn -> Calculation
calculate stringedColumn =
    let
        column =
            Translator.translate stringedColumn

        area =
            column.height * column.width

        requiredReinforcement =
            Calculator.calculateRequiredReinforcement column

        providedReinforcement =
            Calculator.providedReinforcement column.barsCount column.mainBarDiameter

        minimumReinforcement =
            Calculator.minReinforcement area

        maximumReinforcement =
            Calculator.maxReinforcement area

        minimumEccentricity =
            Calculator.minimumEccentricity column.height

        effectiveMoment =
            Calculator.effectiveDesignMoment column.bendingMoment column.axialForce column.height

        utilization =
            if providedReinforcement <= 0 then
                0

            else
                requiredReinforcement / providedReinforcement
    in
    { requiredReinforcement = requiredReinforcement
    , providedReinforcement = providedReinforcement
    , minimumReinforcement = minimumReinforcement
    , maximumReinforcement = maximumReinforcement
    , effectiveMoment = effectiveMoment
    , minimumEccentricity = minimumEccentricity
    , utilization = utilization
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


toSession : Model -> Session
toSession model =
    model.session


view : Model -> { title : String, content : Html Msg }
view model =
    { title = model.pageTitle
    , content =
        Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.lg12, Col.xl9 ]
                    [ Grid.row [ Row.centerMd ]
                        [ Grid.col [ Col.middleXs, Col.lg12, Col.xl6 ]
                            [ Form.render model.column ]
                        , Grid.col [ Col.middleXs, Col.lg12, Col.xl6, Col.attrs [ class "drawing" ] ]
                            [ ColumnDrawing.render model.column ]
                        ]
                    , Grid.row [ Row.centerMd ]
                        (Tables.render model.requiredReinforcement)
                    ]
                , Grid.col [ Col.lg12, Col.xl3 ]
                    [ Grid.row [ Row.centerMd ]
                        [ Results.render model ]
                    ]
                ]
            ]
    }

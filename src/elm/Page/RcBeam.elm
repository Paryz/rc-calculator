module Page.RcBeam exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (..)
import Html.Attributes exposing (..)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , pageTitle = "Rc Beam"
      , pageBody = "This is the rc-beam page"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    let
        gamma =
            String.fromChar (Char.fromCode 947)
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
                                , Input.text [ Input.id "height" ]
                                ]
                            , Form.col [ Col.xs4 ]
                                [ Form.label [ for "width" ] [ text "width - b (mm)" ]
                                , Input.text [ Input.id "width" ]
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
                                , Input.text [ Input.id "concrete-class" ]
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "steel-class" ]
                                    [ text "steel class (MPa)" ]
                                , Input.text [ Input.id "steel-class" ]
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaC" ]
                                    [ text "concrete - "
                                    , text gamma
                                    , sub [] [ text "c" ]
                                    ]
                                , Input.text [ Input.id "gammaC" ]
                                ]
                            , Form.col [ Col.xs3 ]
                                [ Form.label [ for "gammaS" ]
                                    [ text "steel - "
                                    , text gamma
                                    , sub [] [ text "s" ]
                                    ]
                                , Input.text [ Input.id "gammaS" ]
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


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

port module Page.RcColumn exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h2, input, text)
import Html.Attributes exposing (class, id, type_, value)
import Html.Events exposing (onInput)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , pageTitle : String
    , pageBody : String
    , msg : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , pageTitle = "Rc Column"
      , pageBody = "This is the rc-column page"
      , msg = "dupa"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = model.pageTitle
    , content =
        div [ class "container" ]
            [ h2 [] [ text model.pageTitle ]
            , div [ id "fancyClass" ]
                [ text <| Debug.toString model.msg ]
            , div []
                [ input
                    [ type_ "text"
                    , onInput SendToJs
                    , value model.msg
                    ]
                    []
                ]
            ]
    }



-- UPDATE


type Msg
    = UpdateStr String
    | SendToJs String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateStr str ->
            ( { model | msg = str }, Cmd.none )

        SendToJs str ->
            ( model, Cmd.none )



-- port toJs : String -> Cmd msg
-- port toElm : (String -> msg) -> Sub msg
-- port render : String -> Cmd msg
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    --  toElm UpdateStr
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

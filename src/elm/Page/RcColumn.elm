module Page.RcColumn exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
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
      , pageTitle = "Rc Column"
      , pageBody = "This is the rc-column page"
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
            , div [] [ text model.pageBody ]
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

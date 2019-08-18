module Page.AboutUs exposing (Model, Msg, init, subscriptions, toSession, view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, h1, text)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , pageTitle : String
    }


type Msg
    = NoOp


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , pageTitle = "About Us"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = model.pageTitle
    , content =
        Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.middleXs ]
                    [ h1 [] [ text "About Us" ] ]
                ]
            ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

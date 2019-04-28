module Page.AboutUs exposing (Model, Msg, init, subscriptions, toSession, view)

import Asset
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, a, br, div, h1, h3, img, p, text)
import Html.Attributes exposing (class, href, src)
import Route
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , pageTitle : String
    }


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



-- UPDATE


type Msg
    = NoOp



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session

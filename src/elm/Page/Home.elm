module Page.Home exposing (Model, Msg, init, subscriptions, toSession, view)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, a, br, div, h1, h3, img, p, text)
import Html.Attributes exposing (class, href, src)
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
      , pageTitle = "Home"
      , pageBody = "This is the home page"
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
                    [ h1 [] [ text "Welcome to Structy" ] ]
                ]
            , Grid.row []
                [ Grid.col [ Col.middleXs ]
                    [ p []
                        [ text "Free Reinforced Concrete Calculator and"
                        , br [] []
                        , text "PDF Documentation Generator"
                        ]
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.middleXs ]
                    [ h3 [] [ text "..." ] ]
                ]
            , Grid.row []
                [ Grid.col [ Col.middleXs ]
                    [ p [] [ text "Choose element that you want to calculate below" ] ]
                ]
            , Grid.row []
                [ renderImage "align-right" "/rc-beam" "rc-beam.svg" "rc-beam-image" "RC Beam"
                , renderImage "align-left" "/rc-column" "rc-column.svg" "rc-column-image" "RC Column"
                ]
            ]
    }


renderImage : String -> String -> String -> String -> String -> Grid.Column msg
renderImage alignDirection route imageUrl imageClass label =
    Grid.col [ Col.xs6, Col.attrs [ class alignDirection ] ]
        [ a [ href route, class "card-wrapper" ]
            [ Card.config []
                |> Card.block [ Block.attrs [ class "rc-element-image-wrapper" ] ]
                    [ Block.text [] [ img [ src imageUrl, class imageClass ] [] ] ]
                |> Card.view
            , div [ class "rc-element-label" ] [ text label ]
            ]
        ]



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

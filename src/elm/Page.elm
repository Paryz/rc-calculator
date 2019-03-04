module Page exposing (Page(..), view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route)


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type Page
    = Other
    | Home
    | RcBeam


{-| Take a page's Html and frames it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)

-}
view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title ++ " - rc-calculator"
    , body =
        [ div [ class "main" ]
            [ viewHeader
            , content
            , viewFooter
            ]
        ]
    }


viewHeader : Html msg
viewHeader =
    Grid.row []
        [ Grid.col [ Col.middleXs ]
            [ ul [ class "list-inline" ]
                [ li [ class "list-inline-item" ] [ a [ href "/" ] [ text "Home" ] ]
                , li [ class "list-inline-item" ] [ text "About Us" ]
                , li [ class "list-inline-item" ] [ text "Link" ]
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer []
        [ p [ class "coming-soon" ] [ text "More Coming Soon!" ] ]


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]

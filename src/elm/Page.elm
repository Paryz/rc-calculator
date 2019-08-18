module Page exposing (Page(..), view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Browser exposing (Document)
import Html exposing (Html, a, div, footer, li, p, text, ul)
import Html.Attributes exposing (class)
import Route


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type Page
    = Other
    | Home
    | AboutUs
    | RcBeam
    | RcColumn


{-| Take a page's Html and frames it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)

-}
view : { title : String, content : Html msg } -> Document msg
view { title, content } =
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
                [ li [ class "list-inline-item" ] [ a [ Route.href Route.Home ] [ text "Home" ] ]
                , li [ class "list-inline-item" ] [ a [ Route.href Route.AboutUs ] [ text "About Us" ] ]
                , li [ class "list-inline-item" ] [ text "Link" ]
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer []
        [ p [ class "coming-soon" ] [ text "More Coming Soon!" ] ]

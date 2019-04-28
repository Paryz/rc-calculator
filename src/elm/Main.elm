module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Json.Decode exposing (Value)
import Page
import Page.AboutUs as AboutUs
import Page.Blank as Blank
import Page.Home as Home
import Page.NotFound as NotFound
import Page.RcBeam.Model as RcBeam
import Page.RcBeam.View as RcBeamView
import Page.RcColumn as RcColumn
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- WARNING: Based on discussions around how asset management features
-- like code splitting and lazy loading have been shaping up, I expect
-- most of this file to become unnecessary in a future release of Elm.
-- Avoid putting things in here unless there is no alternative!
--
-- MODEL


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | AboutUs AboutUs.Model
    | RcBeam RcBeam.Model
    | RcColumn RcColumn.Model


init : Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey))



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Home homeModel ->
            viewPage Page.Home GotHomeMsg (Home.view homeModel)

        AboutUs aboutUsModel ->
            viewPage Page.AboutUs GotAboutUsMsg (AboutUs.view aboutUsModel)

        RcBeam rcBeamModel ->
            viewPage Page.RcBeam GotRcBeamMsg (RcBeamView.view rcBeamModel)

        RcColumn rcColumnModel ->
            viewPage Page.RcColumn GotRcColumnMsg (RcColumn.view rcColumnModel)



-- UPDATE


type Msg
    = Ignored
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg Home.Msg
    | GotAboutUsMsg AboutUs.Msg
    | GotRcBeamMsg RcBeam.Msg
    | GotRcColumnMsg RcColumn.Msg


toSession : Model -> Session
toSession page =
    case page of
        Redirect session ->
            session

        NotFound session ->
            session

        Home homePage ->
            Home.toSession homePage

        AboutUs aboutUsPage ->
            AboutUs.toSession aboutUsPage

        RcBeam rcBeamPage ->
            RcBeam.toSession rcBeamPage

        RcColumn rcColumnPage ->
            RcColumn.toSession rcColumnPage


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Root ->
            ( model, Route.replaceUrl (Session.navKey session) Route.Home )

        Just Route.Home ->
            Home.init session
                |> updateWith Home GotHomeMsg model

        Just Route.AboutUs ->
            AboutUs.init session
                |> updateWith AboutUs GotAboutUsMsg model

        Just Route.RcBeam ->
            RcBeam.init session
                |> updateWith RcBeam GotRcBeamMsg model

        Just Route.RcColumn ->
            RcColumn.init session
                |> updateWith RcColumn GotRcColumnMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( GotRcBeamMsg subMsg, RcBeam rcBeamModel ) ->
            RcBeam.update subMsg rcBeamModel
                |> updateWith RcBeam GotRcBeamMsg model

        ( GotRcColumnMsg subMsg, RcColumn rcColumnModel ) ->
            RcColumn.update subMsg rcColumnModel
                |> updateWith RcColumn GotRcColumnMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Sub.none

        Home homeModel ->
            Sub.map GotHomeMsg (Home.subscriptions homeModel)

        AboutUs aboutUsModel ->
            Sub.map GotAboutUsMsg (AboutUs.subscriptions aboutUsModel)

        RcBeam rcBeamModel ->
            Sub.map GotRcBeamMsg (RcBeam.subscriptions rcBeamModel)

        RcColumn rcColumnModel ->
            Sub.map GotRcColumnMsg (RcColumn.subscriptions rcColumnModel)



-- MAIN


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }

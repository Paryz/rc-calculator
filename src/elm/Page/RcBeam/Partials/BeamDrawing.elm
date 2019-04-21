module Page.RcBeam.Partials.BeamDrawing exposing (beamDrawing)

import Html
import Page.RcBeam.Translator exposing (Beam)
import Svg exposing (..)
import Svg.Attributes exposing (..)


beamDrawing : Beam -> Svg msg
beamDrawing beam =
    let
        canvasWidth =
            beam.width / 2 + 20

        canvasHeight =
            beam.height / 2 + 20

        scaledWidth =
            beam.width / 2

        scaledHeight =
            beam.height / 2

        scaledMainBarDiameter =
            beam.mainBarDiameter / 2

        scaledLinkDiameter =
            beam.linkDiameter / 2

        scaledCover =
            beam.cover / 2

        translation =
            "translate(" ++ String.fromFloat (scaledCover + 10) ++ "," ++ String.fromFloat (scaledCover + 10) ++ ")"

        linkOuterHeight =
            scaledHeight - 2 * scaledCover

        linkOuterWidth =
            scaledWidth - 2 * scaledCover

        linkOuterRadius diameter =
            if diameter >= 16 then
                scaledLinkDiameter * 4.5

            else
                scaledLinkDiameter * 3

        linkInnerHeight =
            scaledHeight - 2 * (scaledCover + scaledLinkDiameter)

        linkInnerWidth =
            scaledWidth - 2 * (scaledCover + scaledLinkDiameter)

        linkInnerRadius diameter =
            if diameter >= 16 then
                scaledLinkDiameter * 3.5

            else
                scaledLinkDiameter * 2
    in
    svg [ width (String.fromFloat canvasWidth), height (String.fromFloat canvasHeight) ]
        [ rect
            [ x "10"
            , y "10"
            , width (String.fromFloat scaledWidth)
            , height (String.fromFloat scaledHeight)
            , Svg.Attributes.style "stroke:black;fill:lightgrey"
            ]
            []
        , g [ transform translation ]
            [ rect
                [ width (String.fromFloat linkOuterWidth)
                , height (String.fromFloat linkOuterHeight)
                , rx (String.fromFloat (linkOuterRadius beam.linkDiameter))
                , ry (String.fromFloat (linkOuterRadius beam.linkDiameter))
                ]
                []
            , rect
                [ x (String.fromFloat scaledLinkDiameter)
                , y (String.fromFloat scaledLinkDiameter)
                , width (String.fromFloat linkInnerWidth)
                , height (String.fromFloat linkInnerHeight)
                , rx (String.fromFloat (linkInnerRadius beam.linkDiameter))
                , ry (String.fromFloat (linkInnerRadius beam.linkDiameter))
                , Svg.Attributes.style "stroke:black;fill:lightgrey"
                ]
                []
            ]
        ]

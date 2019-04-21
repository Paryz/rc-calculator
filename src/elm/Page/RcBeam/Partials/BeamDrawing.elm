module Page.RcBeam.Partials.BeamDrawing exposing (beamDrawing)

import Html
import Page.RcBeam.Translator exposing (Beam)
import Svg exposing (..)
import Svg.Attributes exposing (..)


beamDrawing : Beam -> Svg msg
beamDrawing beam =
    let
        scale =
            if beam.height < 900 then
                "scale(0.5)"

            else
                "scale(0.25)"

        canvasWidth =
            beam.width / 2 + 20

        canvasHeight =
            if beam.height < 900 then
                beam.height / 2 + 20

            else
                beam.height / 4 + 20

        scaledWidth =
            beam.width

        scaledHeight =
            beam.height

        scaledMainBarDiameter =
            beam.mainBarDiameter

        scaledLinkDiameter =
            beam.linkDiameter

        scaledCover =
            beam.cover

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
    svg [ width <| String.fromFloat canvasWidth, height <| String.fromFloat canvasHeight ]
        [ g [ transform scale ]
            [ rect
                [ x "10"
                , y "10"
                , width <| String.fromFloat scaledWidth
                , height <| String.fromFloat scaledHeight
                , Svg.Attributes.style "stroke:black;fill:lightgrey"
                ]
                []
            , g [ transform translation ]
                [ rect
                    [ width <| String.fromFloat linkOuterWidth
                    , height <| String.fromFloat linkOuterHeight
                    , rx <| String.fromFloat <| linkOuterRadius beam.linkDiameter
                    , ry <| String.fromFloat <| linkOuterRadius beam.linkDiameter
                    ]
                    []
                , rect
                    [ x <| String.fromFloat scaledLinkDiameter
                    , y <| String.fromFloat scaledLinkDiameter
                    , width <| String.fromFloat linkInnerWidth
                    , height <| String.fromFloat linkInnerHeight
                    , rx <| String.fromFloat <| linkInnerRadius beam.linkDiameter
                    , ry <| String.fromFloat <| linkInnerRadius beam.linkDiameter
                    , Svg.Attributes.style "stroke:black;fill:lightgrey"
                    ]
                    []
                ]
            ]
        ]

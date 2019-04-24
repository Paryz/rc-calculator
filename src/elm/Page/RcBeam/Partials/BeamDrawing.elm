module Page.RcBeam.Partials.BeamDrawing exposing (beamDrawing)

import Array
import Calculator.Diameters as Diameters
import Calculator.Types as Types
import Html
import Page.RcBeam.Translator exposing (Beam)
import Svg exposing (..)
import Svg.Attributes exposing (..)


beamDrawing : Beam -> Types.ReqReinforcement -> Svg msg
beamDrawing beam reqReinforcement =
    let
        scale =
            if beam.height < 900 then
                "scale(0.5)"

            else
                "scale(0.25)"

        canvasWidth =
            beam.width / 2 + 10

        canvasHeight =
            if beam.height < 900 then
                beam.height / 2 + 20

            else
                beam.height / 4 + 20

        linkTranslation =
            "translate(" ++ String.fromFloat (beam.cover + 10) ++ "," ++ String.fromFloat (beam.cover + 10) ++ ")"

        linkOuterHeight =
            beam.height - 2 * beam.cover

        linkOuterWidth =
            beam.width - 2 * beam.cover

        linkOuterRadius diameter =
            if diameter >= 16 then
                beam.linkDiameter * 4.5

            else
                beam.linkDiameter * 3

        linkInnerHeight =
            beam.height - 2 * (beam.cover + beam.linkDiameter)

        linkInnerWidth =
            beam.width - 2 * (beam.cover + beam.linkDiameter)

        linkInnerRadius diameter =
            if diameter >= 16 then
                beam.linkDiameter * 3.5

            else
                beam.linkDiameter * 2

        ( topBars, bottomBars ) =
            fetchBars beam.mainBarDiameter reqReinforcement

        topMainBarTranslation =
            let
                mainBarDistance =
                    beam.mainBarDiameter + beam.linkDiameter
            in
            "translate(" ++ String.fromFloat mainBarDistance ++ "," ++ String.fromFloat mainBarDistance ++ ")"

        topBarsDrawing =
            mainReinforcement topBars beam

        bottomMainBarTranslation =
            let
                mainBarHorizontalDistance =
                    beam.mainBarDiameter + beam.linkDiameter

                mainBarVerticalDistance =
                    beam.mainBarDiameter + beam.linkDiameter + beam.height - 2 * beam.cover - 2 * beam.linkDiameter - 2 * beam.mainBarDiameter
            in
            "translate(" ++ String.fromFloat mainBarHorizontalDistance ++ "," ++ String.fromFloat mainBarVerticalDistance ++ ")"

        bottomBarsDrawing =
            mainReinforcement bottomBars beam
    in
    svg [ width <| String.fromFloat canvasWidth, height <| String.fromFloat canvasHeight ]
        [ g [ transform scale ]
            [ rect
                [ x "10"
                , y "10"
                , width <| String.fromFloat beam.width
                , height <| String.fromFloat beam.height
                , Svg.Attributes.style "stroke:black;fill:lightgrey"
                ]
                []
            , g [ transform linkTranslation ]
                [ rect
                    [ width <| String.fromFloat linkOuterWidth
                    , height <| String.fromFloat linkOuterHeight
                    , rx <| String.fromFloat <| linkOuterRadius beam.linkDiameter
                    , ry <| String.fromFloat <| linkOuterRadius beam.linkDiameter
                    ]
                    []
                , rect
                    [ x <| String.fromFloat beam.linkDiameter
                    , y <| String.fromFloat beam.linkDiameter
                    , width <| String.fromFloat linkInnerWidth
                    , height <| String.fromFloat linkInnerHeight
                    , rx <| String.fromFloat <| linkInnerRadius beam.linkDiameter
                    , ry <| String.fromFloat <| linkInnerRadius beam.linkDiameter
                    , Svg.Attributes.style "stroke:black;fill:lightgrey"
                    ]
                    []
                , g [ transform topMainBarTranslation ]
                    topBarsDrawing
                , g [ transform bottomMainBarTranslation ]
                    bottomBarsDrawing
                ]
            ]
        ]


mainReinforcement : Int -> Beam -> List (Svg msg)
mainReinforcement count beam =
    let
        interval =
            count - 1

        widthPrime =
            beam.width - 2 * beam.cover - 2 * beam.linkDiameter - 2 * beam.mainBarDiameter

        intervalDistnace =
            widthPrime / Basics.toFloat interval
    in
    interval
        |> List.range 0
        |> List.map Basics.toFloat
        |> List.map (\item -> item * intervalDistnace)
        |> List.map (\offset -> circle [ cx <| String.fromFloat offset, r <| String.fromFloat beam.mainBarDiameter ] [])


fetchBars : Types.MainBarDiameter -> Types.ReqReinforcement -> ( Int, Int )
fetchBars diameter ( topReinforcement, bottomReinforcement ) =
    let
        barSectionList =
            Diameters.mapDiameterToReinforcementList diameter

        topBars =
            barCount barSectionList topReinforcement

        bottomBars =
            barCount barSectionList bottomReinforcement
    in
    ( topBars, bottomBars )


barCount : List Int -> Int -> Int
barCount barSectionList sideOfReinforcement =
    barSectionList
        |> List.filter (\value -> value <= sideOfReinforcement)
        |> List.length
        |> (+) 1
        |> minimalBarNumber


minimalBarNumber : Int -> Int
minimalBarNumber value =
    if value == 1 then
        2

    else
        value

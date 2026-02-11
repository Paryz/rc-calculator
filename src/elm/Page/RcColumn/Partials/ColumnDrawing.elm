module Page.RcColumn.Partials.ColumnDrawing exposing (render)

import Page.RcColumn.Translator as Translator
import Page.RcColumn.Types exposing (Column, StringedColumn)
import Svg exposing (Svg, circle, g, rect, svg)
import Svg.Attributes exposing (cx, cy, fill, height, r, rx, ry, stroke, strokeWidth, transform, width, x, y)


render : StringedColumn -> Svg msg
render stringedColumn =
    let
        column =
            Translator.translate stringedColumn

        framePadding =
            10

        scale =
            if column.width < 700 && column.height < 900 then
                "scale(0.5)"

            else
                "scale(0.25)"

        ( canvasWidth, canvasHeight ) =
            if column.width < 700 && column.height < 900 then
                ( column.width / 2 + 20, column.height / 2 + 20 )

            else
                ( column.width / 4 + 20, column.height / 4 + 20 )

        coverLineWidth =
            max 1 (column.mainBarDiameter / 4)

        bars =
            reinforcementBars column
    in
    svg [ width <| String.fromFloat canvasWidth, height <| String.fromFloat canvasHeight ]
        [ g [ transform scale ]
            [ rect
                [ x <| String.fromInt framePadding
                , y <| String.fromInt framePadding
                , width <| String.fromFloat column.width
                , height <| String.fromFloat column.height
                , stroke "black"
                , strokeWidth "2"
                , fill "#d3d3d3"
                ]
                []
            , rect
                [ x <| String.fromFloat (toFloat framePadding + column.cover)
                , y <| String.fromFloat (toFloat framePadding + column.cover)
                , width <| String.fromFloat (max 1 (column.width - 2 * column.cover))
                , height <| String.fromFloat (max 1 (column.height - 2 * column.cover))
                , rx <| String.fromFloat (column.mainBarDiameter / 2)
                , ry <| String.fromFloat (column.mainBarDiameter / 2)
                , stroke "black"
                , strokeWidth <| String.fromFloat coverLineWidth
                , fill "none"
                ]
                []
            , g [ transform <| "translate(" ++ String.fromInt framePadding ++ "," ++ String.fromInt framePadding ++ ")" ] bars
            ]
        ]


reinforcementBars : Column -> List (Svg msg)
reinforcementBars column =
    let
        barsCount =
            max 4 column.barsCount

        d =
            column.mainBarDiameter

        xLeft =
            column.cover + d / 2

        xRight =
            column.width - column.cover - d / 2

        yTop =
            column.cover + d / 2

        yBottom =
            column.height - column.cover - d / 2

        cornerBars =
            [ ( xLeft, yTop ), ( xRight, yTop ), ( xLeft, yBottom ), ( xRight, yBottom ) ]

        extraBarsNeeded =
            barsCount - List.length cornerBars

        topBottomSpan =
            max 1 (xRight - xLeft)

        sideSpan =
            max 1 (yBottom - yTop)

        extraBars =
            List.range 1 extraBarsNeeded
                |> List.map (extraBarPosition extraBarsNeeded xLeft xRight yTop yBottom topBottomSpan sideSpan)

        allBars =
            cornerBars ++ extraBars
    in
    List.map (barSvg d) allBars


extraBarPosition : Int -> Float -> Float -> Float -> Float -> Float -> Float -> Int -> ( Float, Float )
extraBarPosition total xLeft xRight yTop yBottom topBottomSpan sideSpan index =
    let
        t =
            toFloat index / toFloat (total + 1)

        side =
            modBy 4 index
    in
    case side of
        0 ->
            ( xLeft + topBottomSpan * t, yTop )

        1 ->
            ( xLeft + topBottomSpan * t, yBottom )

        2 ->
            ( xLeft, yTop + sideSpan * t )

        _ ->
            ( xRight, yTop + sideSpan * t )


barSvg : Float -> ( Float, Float ) -> Svg msg
barSvg diameter ( xValue, yValue ) =
    circle
        [ cx <| String.fromFloat xValue
        , cy <| String.fromFloat yValue
        , r <| String.fromFloat (diameter / 2)
        , fill "#2f80ed"
        , stroke "#0f3f82"
        , strokeWidth "1.5"
        ]
        []

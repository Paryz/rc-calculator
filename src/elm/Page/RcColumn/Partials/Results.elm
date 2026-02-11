module Page.RcColumn.Partials.Results exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (strong, text)
import Html.Attributes exposing (id)
import Page.RcColumn.Types exposing (Model)
import Round


render : Model -> Grid.Column msg
render model =
    let
        isWithinMinMax =
            model.providedReinforcement >= model.minimumReinforcement && model.providedReinforcement <= model.maximumReinforcement

        isSufficient =
            model.providedReinforcement >= model.requiredReinforcement

        utilizationLabel =
            if isSufficient && isWithinMinMax then
                "Section OK"

            else
                "Increase section or reinforcement"
    in
    Grid.col [ Col.xs12 ]
        [ Html.div [ id "results" ]
            [ Html.p [] [ text <| "Required reinforcement As,req = " ++ Round.round 1 model.requiredReinforcement ++ " mm2" ]
            , Html.p [] [ text <| "Provided reinforcement As,prov = " ++ Round.round 1 model.providedReinforcement ++ " mm2" ]
            , Html.p [] [ text <| "As,min = " ++ Round.round 1 model.minimumReinforcement ++ " mm2" ]
            , Html.p [] [ text <| "As,max = " ++ Round.round 1 model.maximumReinforcement ++ " mm2" ]
            , Html.p [] [ text <| "e,min = " ++ Round.round 1 model.minimumEccentricity ++ " mm" ]
            , Html.p [] [ text <| "M,Ed,eff = " ++ Round.round 1 model.effectiveMoment ++ " kNm" ]
            , Html.p [] [ text <| "Utilization (As,req / As,prov) = " ++ Round.round 3 model.utilization ]
            , Html.p [] [ strong [] [ text utilizationLabel ] ]
            ]
        ]

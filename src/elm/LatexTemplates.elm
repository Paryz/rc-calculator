module LatexTemplates exposing (render)

import Html exposing (Html)
import MiniLatex.MiniLatex as MiniLatex


render : String -> Html msg
render sourceText =
    let
        macroDefinitions =
            normalize macros
    in
    MiniLatex.render macroDefinitions sourceText


normalize : String -> String
normalize str =
    str |> String.lines |> List.filter (\x -> x /= "") |> String.join "\n"


macros =
    """
\\newcommand{\\bra}{\\langle}
\\newcommand{\\ket}{\\rangle}
\\newcommand{\\set}[1]{\\{\\ #1 \\ \\}}
\\newcommand{\\sett}[2]{\\{\\ #1 \\ |\\ #2 \\}}
\\newcommand{\\id}{\\mathbb{\\,I\\,}}
"""

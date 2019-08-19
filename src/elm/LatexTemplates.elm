module LatexTemplates exposing (normalized_macros)


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


normalized_macros : String
normalized_macros =
    normalize macros

module LatexTemplates.RcBeam exposing (template)


template : String
template =
    """

$\\require{\\AMScd}$

$\\require{\\mhchem}$

\\begin{equation}
\\label{integral:xn}
\\int_0^1 x^n dx = \\frac{1}{n+1}
\\end{equation}

    """

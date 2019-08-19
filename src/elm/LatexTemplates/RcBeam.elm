module LatexTemplates.RcBeam exposing (template, template2)


template : String
template =
    """
    $\\require{\\AMScd}$
    $\\require{\\mhchem}$
    \\begin{document}
    \\begin{align*}
    \\int_0^1 x^n dx = \\frac{1}{n+1}
    \\end{align*}
    \\end{document}
    """


template2 : String
template2 =
    """

$\\require{\\AMScd}$

$\\require{\\mhchem}$


\\title{MiniLatex Demo}
% \\author{James Carlson}
% \\email{jxxcarlson@gmail.com}
% \\date{August 5, 2018}s



\\maketitle

% EXAMPLE 1

\\begin{comment}
This multi-line comment
should also not
be visible in the
rendered text.
\\end{comment}


\\tableofcontents

\\section{Introduction}

MiniLatex is a subset of LaTeX that can be
rendered live in the browser. Feel free to
experiment with MiniLatex using this app
\\mdash you can change the text in the
left-hand window, or clear it and enter
your own text.

MiniLatex is still a research project, albeit
advancing rapidly.  I need your feedback to make
it better: jxxcarlson at gmail.  See \\cite{H},
\\cite{T} below for articles on the design of
MiniLatex.  The source code is at \\cite{S}.
We are using an experimental version of the
code here that will be released in the
Fall of 2018.

For a searchable repository of MiniLatex documents,
see \\href{https://knode.io}{knode.io}.
You can create, edit, and disseminate documents
using \\strong{knode}.  For an example of a long
MiniLatex document, see
\\href{https://www.knode.io/424}{QF Notes}
\\mdash then click on the title.
\\section{Formulas}

\\italic{Try editing formula \\eqref{integral:xn} or \\eqref{integral:exp} below.}

The most basic integral:

\\begin{equation}
\\label{integral:xn}
\\int_0^1 x^n dx = \\frac{1}{n+1}
\\end{equation}

An improper integral:

\\begin{equation}
\\label{integral:exp}
\\int_0^\\infty e^{-x} dx = 1
\\end{equation}

\\section{Commutative diagrams}

For commutative diagrams, use the AMScd
package, so we first say this:

\\begin{verbatim}
$\\require{\\AMScd}$
\\end{verbatim}

Then we proceed as usual to write these:


$$
\\begin{CD}
A @<<< B @>>> C\\\\
@. @| @AAA\\\\
@. D @= E
\\end{CD}
$$

$$
\\begin{CD}
K(X) @>{ch}>> H(X;\\mathbb Q)\\\\
@VVV @VVV \\\\
K(Y) @>{ch}>> H(Y;\\mathbb Q)
\\end{CD}
$$

\\section{Chemistry}

With the \\code{mchem} package, you
can write chemical formulas.  First say this:

\\begin{verbatim}
$\\require{\\mchem}$
\\end{verbatim}

Then proceed as usual:




$\\ce{H2O}$

$\\ce{CO2 + C -> 2 CO}$

$\\ce{SO4^2-}$

$\\ce{(NH4)2S}$

$\\ce{^{227}_{90}Th+}$

$\\ce{C6H5-CHO}$

$\\ce{SO4^2- + Ba^2+ -> BaSO4 v}$


\\section{Math-mode Macros}

A little Dirac notation \\cite{D} from quantum mechanics:

$$
  \\bra x | y \\ket = \\bra y | x \\ket.
$$

The \\strong{bra} and \\strong{ket} macros are defined
in the panel on the right.  You can always define and
use math-mode macros in MiniLatex.

More macros \\mdash see the right-hand panel for their
definitions:

$A = \\set{a \\in Z, a \\equiv 1\\ mod\\ 2}$

$B = \\sett{a,b,c}{a,b,c \\in Z}$

Note that you can easily write
about Tex in MiniLatex.
Thus the  \\code{\\backslash{bra }}
macro is defined as
\\code{\\backslash{newcommand}\\texarg{\\backslash{bra}}\\texarg{\\backslash{langle}}}.

\\section{Text-mode Macros}

\\newcommand{\\hello}[1]{Hello \\strong{#1}!}




We have added an experimental macro expansion feature that permits
the author to define new text-mode macros in a MiniLatex document.
For example, if we add the text

\\newcommand{\\boss}{Phineas Fogg}

\\begin{verbatim}
\\newcommand{\\boss}{Phineas Fogg}
\\end{verbatim}

then saying

\\begin{verbatim}
\\italic{My boss is \\boss.}
\\end{verbatim}

produces \\italic{My boss is \\boss.}
Likewise, if one says

\\begin{verbatim}
\\newcommand{\\hello}[1]{Hello \\strong{#1}!}
\\end{verbatim}

then the macro \\backslash{hello}\\texarg{John} renders as \\hello{John}
For one more example,  make the definition

\\begin{verbatim}
\\newcommand{\\reverseconcat}[3]{#3#2#1}
\\end{verbatim}

\\newcommand{\\reverseconcat}[3]{#3#2#1}

Then \\backslash{reverseconcat}\\texarg{A}\\texarg{B}\\texarg{C} = \\reverseconcat{A}{B}{C}

The macro expansion feature will need a lot more work and testing.
We also plan to add a feature so that authors can define new environments.



\\section{MiniLatex Macros}

MiniLatex has a number of macros of its own,  For
example, text can be rendered in various colors, \\red{such as red}
and \\blue{blue}. Text can \\highlight{be highlighted}
and can \\strike{also be struck}. Here are the macros:

\\begin{verbatim}
\\red
\\blue
\\highlight
\\strike
\\end{verbatim}


\\section{Theorems}

\\begin{theorem}
There are infinitely many prime numbers.
\\end{theorem}

\\begin{theorem}
There are infinitley many prime numbers
$p$ such that $p \\equiv 1\\ mod\\ 4$.
\\end{theorem}

\\section{Images}

\\image{http://psurl.s3.amazonaws.com/images/jc/beats-eca1.png}{Figure 1. Two-frequency beats}{width: 350, align: center}

\\section{Lists and Tables}

A list

\\begin{itemize}

\\item This is \\strong{just} a test.

\\item \\italic{And so is this:} $a^2 + b^2 = c^2$

\\begin{itemize}

\\item Items can be nested

\\item And you can do this:
$ \\frac{1}{1 + \\frac{2}{3}} $

\\end{itemize}

\\end{itemize}

A table

\\begin{indent}
\\strong{Light Elements}
\\begin{tabular}{ l l l l }
Hydrogen & H & 1 & 1.008 \\\\
Helium & He & 2 & 4.003 \\\\
Lithium& Li & 3 & 6.94 \\\\
Beryllium& Be& 4& 9.012 \\\\
\\end{tabular}
\\end{indent}

\\section{Errors and related matters}

\\href{http://nytimes.com}{NYT

Pythagoras is said to have said that $z^2 + b^2 = c^2

Errors, as illustrated above, are rendered in real time and are reported in red, in place. Compare
with the source text on the left.

We plan to make error reporting still better, giving detailed context.  Note, by the way, what happens when a nonexistent macro like \\italic{hohoho } is used:

\\begin{indent}
\\hohoho{123}
\\end{indent}

This is intentional.  Note also what happens when we use a nonexistent environment like \\italic{joke}:

\\begin{joke}
Did you hear the one about the mathematician, the philosopher, and the engineer?
\\end{joke}

This default treatment of unkown environments is also intentional, and can even be useful.

\\section{Technology}

MiniLatex is written in \\href{http://elm-lang.org}{Elm}, the statically typed functional
programming language created by Evan Czaplicki.  Because of its excellent
\\href{http://package.elm-lang.org/packages/elm-tools/parser/latest}{parser combinator library}, Elm is an ideal choice for a project like the present one.


For an overview of the design of MiniLatex, see
\\href{https://hackernoon.com/towards-latex-in-the-browser-2ff4d94a0c08}{Towards Latex in the Browser}.
Briefly, \\href{https://www.mathjax.org/}{MathJax} is used inside dollar signs, and Elm is used outside.

\\bigskip


\\section{References}

\\begin{thebibliography}

\\bibitem{D} \\href{https://ocw.mit.edu/courses/physics/8-05-quantum-physics-ii-fall-2013/lecture-notes/MIT8_05F13_Chap_04.pdf}{On Dirac's bra-ket notation}, MIT Courseware.

\\bibitem{G} James Carlson, \\href{https://knode.io/628}{MiniLaTeX Grammar},

\\bibitem{H} James Carlson, \\href{https://hackernoon.com/towards-latex-in-the-browser-2ff4d94a0c08}{Towards LaTeX in the Browser }, Hackernoon

\\bibitem{S} \\href{http://package.elm-lang.org/packages/jxxcarlson/minilatex/latest}{Source code}

\\bibitem{T} James Carlson, \\href{https://knode.io/525}{MiniLatex Technical Report}

\\end{thebibliography}




"""

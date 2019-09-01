import katex from 'katex'

const katexRender = (template, elem) => {
  katex.render(template, elem, {
    throwOnError: true,
    output: 'html',
    displayMode: true
  });
}

// concrete details section
const fctm = (fck) => {
  if(fck <= '50') {
    return (`0.3\\frac{N}{mm^2} * (\\frac{f_{ck}}{\\frac{N}{mm^2}})^\\frac{2}{3}`)
  } else {
    return (`2.12*\\ln(1+\\frac{f_{cm}}{10})`)
  }
}

const resultsTemplate = (beam) => (`
  \\begin{aligned}
  \\LARGE Concret&\\LARGE e\\ Details \\\\
  f_{ck} &= ${beam.concreteClass}\\frac{N}{mm^2} \\\\
  f_{cm} &= f_{ck} + 8\\frac{N}{mm^2} = ${parseInt(beam.concreteClass)+8}\\frac{N}{mm^2} \\\\
  f_{ctm} &= ${fctm(beam.concreteClass)} = ${beam.fctm}\\frac{N}{mm^2} \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  \\gamma_C &= ${beam.concreteFactor} \\\\
  \\alpha_{cc} &= 0.85 \\\\
  f_{cd} &= \\frac{\\alpha_{cc} * f_{ck}}{\\gamma_C} = ${beam.fcd}\\frac{N}{mm^2} \\\\
  f_{yk} &= ${beam.steelClass}\\frac{N}{mm^2} \\\\
  \\gamma_S &= ${beam.steelFactor} \\\\
  f_{yd} &= \\frac{f_{yk}}{\\gamma_S} = ${beam.fyd}\\frac{N}{mm^2} \\\\
  c_{nom} &= ${beam.cover}mm \\\\
  \\\\
  \\LARGE RC\\ Sect&\\LARGE ion\\ Details \\\\
  height &= ${beam.height}mm \\\\
  width &= ${beam.width}mm \\\\
  bending moment &= ${beam.bendingMoment}\\frac{N}{mm^2}\\\\
  \\end{aligned}
`)

export function renderResults(beam, node) {
  katexRender(resultsTemplate(beam), node)
}

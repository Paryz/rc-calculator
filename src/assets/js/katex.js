const katex = require('katex');

function katexRender(fun, elem) {
  katex.render(fun, elem, {
    throwOnError: false,
    output: 'html',
    displayMode: true
  });
}

const fck = (beam) => (`f_{ck} = ${beam.concreteClass}\\frac{N}{mm^2}`)
const fcm = (beam) => (`f_{cm} = f_{ck} + 8\\frac{N}{mm^2} = ${parseInt(beam.concreteClass)+8}\\frac{N}{mm^2}`)
const fctm = (beam) => (`f_{ctm} = 0.3\\frac{N}{mm^2} * (\\frac{f_{ck}}{\\frac{N}{mm^2}})^\\frac{2}{3} = 2.9\\frac{N}{mm^2}`)
const eps2 = '\\varepsilon_{cu2} = 0.0035'
const eps3 = '\\varepsilon_{cu2} = 0.0035'
const concreteFactor = (beam) => (`\\gamma_C = ${beam.concreteFactor}`)
const alphacc = '\\alpha_{cc} = 0.85'
const fcd = (beam) => (`f_{cd} = \\frac{\\alpha_{cc} * f_{ck}}{\\gamma_C} = 17.0\\frac{N}{mm^2}`)
const fyk = (beam) => (`f_{yk} = ${beam.steelClass}\\frac{N}{mm^2}`)
const steelFactor = (beam) => (`\\gamma_S = ${beam.steelFactor}`)
const fyd = (beam) => (`f_{yd} = \\frac{f_{yk}}{\\gamma_S} = 435\\frac{N}{mm^2}`)
const concreteCover = (beam) => (`c_{nom} = ${beam.cover}mm`)


export function renderResults(beam, elements) {
  katexRender(fck(beam), elements.fck)
  katexRender(fcm(beam), elements.fcm)
  katexRender(fctm(beam), elements.fctm)
  katexRender(eps2, elements.eps2)
  katexRender(eps3, elements.eps3)
  katexRender(concreteFactor(beam), elements.concreteFactor)
  katexRender(alphacc, elements.alphacc)
  katexRender(fcd(beam), elements.fcd)
  katexRender(fyk(beam), elements.fyk)
  katexRender(steelFactor(beam), elements.steelFactor)
  katexRender(fyd(beam), elements.fyd)
  katexRender(concreteCover(beam), elements.concreteCover)
}

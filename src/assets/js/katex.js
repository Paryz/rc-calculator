import katex from 'katex'

const katexRender = (template, elem) => {
  katex.render(template, elem, {
    throwOnError: true,
    output: 'html',
    displayMode: true
  });
}

const fctmTex = (beam) => {
  if(beam.concreteClass <= '50') {
    return (`
      f_{ctm} &= 0.3 * f_{ck}^\\frac{2}{3} = 0.3 * ${beam.concreteClass}^\\frac{2}{3} = ${beam.fctm}MPa \\\\
    `)
  } else {
    return (`
      f_{cm} &= f_{ck} + 8MPa = ${parseInt(beam.concreteClass)+8}Mpa \\\\
      f_{ctm} &= 2.12*\\ln(1+\\frac{f_{cm}}{10}) = ${beam.fctm}MPa \\\\
    `)
  }
}

const minReinforcement1 = ({fctm, steelClass, width, effectiveHeight}) => (
  0.26*(fctm/steelClass)*width*effectiveHeight
)
const minReinforcement2 = ({width, effectiveHeight}) => (0.0013*width*effectiveHeight)

const resultsTemplate = (beam) => {
  const {
    height,
    width,
    cover,
    mainBarDiameter,
    linkDiameter,
    bendingMoment,
    concreteClass,
    concreteFactor,
    fcd,
    steelClass,
    steelFactor,
    fyd,
    effectiveHeight,
    fctm,
    sC,
    ksiEffective,
    ksiEffectiveLim,
  } = beam
return `
  \\begin{aligned}
  \\LARGE RC\\ Sec&\\LARGE tion\\ Details \\\\
  h &= ${height}mm \\\\
  b &= ${width}mm \\\\
  c_{nom} &= ${cover}mm \\\\
  \\phi &= ${mainBarDiameter}mm \\\\
  \\phi_{S} &= ${linkDiameter}mm \\\\
  M_{Ed} &= ${bendingMoment}kNm \\\\
  \\LARGE Concre&\\LARGE te\\ Details \\\\
  f_{ck} &= ${concreteClass}MPa \\\\
  \\gamma_C &= ${concreteFactor} \\\\
  \\alpha_{cc} &= 0.85 \\\\
  f_{cd} &= \\frac{\\alpha_{cc} * f_{ck}}{\\gamma_C} = \\frac{0.85*${concreteClass}}{${concreteFactor}} = ${fcd}MPa \\\\
  ${fctmTex(beam)}
  \\LARGE Steel\\ &\\LARGE Details \\\\
  f_{yk} &= ${steelClass}MPa \\\\
  \\gamma_S &= ${steelFactor} \\\\
  f_{yd} &= \\frac{f_{yk}}{\\gamma_S} = \\frac{${steelClass}}{${steelFactor}} = ${fyd}MPa \\\\
  \\LARGE Minim&\\LARGE um\\ Reinforcement \\\\
  d &= h - c_{nom} - \\phi_{S} - \\frac{\\phi}{2} = ${height} - ${cover} - ${linkDiameter} - \\frac{${mainBarDiameter}}{2} = ${effectiveHeight}mm \\\\
  A_{s,min,1} &= 0.26*\\frac{f_{ctm}}{f_{yk}}*b*d = 0.26*\\frac{${fctm}}{${steelClass}}*${width}*${effectiveHeight} = ${minReinforcement1(beam)}mm^2 \\\\
  A_{s,min,2} &= 0.0013*b*d = 0.0013*${width}*${effectiveHeight} = ${minReinforcement2(beam)}mm^2 \\\\
  A_{s,min} &= max(A_{s,min,1}, A_{s,min,2}) = max(${minReinforcement1(beam)}, ${minReinforcement2(beam)}) = ${Math.max(minReinforcement1(beam), minReinforcement2(beam))}mm^2 \\\\
  \\LARGE Requir&\\LARGE ed\\ Reinforcement \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  E_{S} &= 200000 MPa \\\\
  S_{C} &= \\frac{M_{Ed}}{f_{cd}*b*d} = \\frac{${bendingMoment}}{${fcd}*${width}*${effectiveHeight}} = ${sC} \\\\
  \\xi_{eff} &= 1 - \\sqrt{1-2*S_{C}} = 1 - \\sqrt{1-2*${sC}} = ${ksiEffective} \\\\
  \\xi_{eff,lim} &= 0.8 * \\frac{\\varepsilon_{cu2}}{\\varepsilon_{cu2}+\\frac{f_{yd}}{E_{S}}} = 0.8 * \\frac{0.0035}{0.0035+\\frac{${fyd}}{200000}} = ${ksiEffectiveLim} \\\\
  \\\\
  \\end{aligned}
`}

export function renderResults(beam, node) {
  katexRender(resultsTemplate(beam), node)
}

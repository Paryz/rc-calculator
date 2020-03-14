import katex from 'katex'

const katexRender = (template, elem) => {
  katex.render(template, elem, {
    throwOnError: true,
    output: 'html',
    displayMode: true
  });
}

const roundToOneDecimalPlaces = (stringedNumber) => (
  Math.round((stringedNumber*100)/100).toFixed(1)
)

const fctmTex = (beam) => {
  if(beam.concreteClass <= '50') {
    return (`
      f_{ctm} &= ${beam.fctm}MPa \\\\
    `)
  } else {
    return (`
      f_{cm} &= ${parseInt(beam.concreteClass)+8}Mpa \\\\
      f_{ctm} &= ${beam.fctm}MPa \\\\
    `)
  }
}

const requiredReinforcement = (beam) => {
  if(beam.ksiEffectiveLim > beam.ksiEffective) {
    return (`
      A_{s,1} &= ${roundToOneDecimalPlaces(beam.bottomReqReinforcement)}mm^2 \\\\
      A_{s,1} &> A_{s,min} \\\\
      A_{s,req} &= ${roundToOneDecimalPlaces(beam.bottomReqReinforcement)}mm^2 \\\\
      `)
  } else {
    return (`
      A_{s,1} &= ${roundToOneDecimalPlaces(beam.bottomReinforcementPrime)}mm^2 \\\\
      M_{sd}' &= ${roundToOneDecimalPlaces(beam.bendingMomentPrime)}kNm \\\\
      A_{s,2} &= ${roundToOneDecimalPlaces(beam.topReqReinforcement)}mm^2 \\\\
      A_{s} &= ${roundToOneDecimalPlaces(beam.bottomReqReinforcement)}mm^2 \\\\
      A_{s,max} &= ${roundToOneDecimalPlaces(beam.maximumReinforcement)}mm^2 \\\\
      `)

  }
}

const minReinforcement1 = ({fctm, steelClass, width, effectiveHeight}) => (
  (Math.round((0.26*(fctm/steelClass)*width*effectiveHeight)*100)/100).toFixed(1)
)
const minReinforcement2 = ({width, effectiveHeight}) => (
  (Math.round((0.0013*width*effectiveHeight)*100)/100).toFixed(1)
)

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
    alphaCC,
    fyd,
    effectiveHeight,
    sC,
    ksiEffective,
    ksiEffectiveLim,
  } = beam
return `
  \\begin{aligned}
  \\large RC\\ Sec&\\large tion\\ Details \\\\
  h &= ${height}mm \\\\
  b &= ${width}mm \\\\
  c_{nom} &= ${cover}mm \\\\
  \\phi &= ${mainBarDiameter}mm \\\\
  \\phi_{S} &= ${linkDiameter}mm \\\\
  M_{Ed} &= ${bendingMoment}kNm \\\\
  \\\\
  \\large Concre&\\large te\\ Details \\\\
  f_{ck} &= ${concreteClass}MPa \\\\
  \\gamma_C &= ${concreteFactor} \\\\
  \\alpha_{cc} &= ${alphaCC} \\\\
  f_{cd} &= ${fcd}MPa \\\\
  ${fctmTex(beam)}
  \\\\
  \\large Steel\\ &\\large Details \\\\
  f_{yk} &= ${steelClass}MPa \\\\
  \\gamma_S &= ${steelFactor} \\\\
  f_{yd} &= ${fyd}MPa \\\\
  \\\\
  \\large Minim&\\large um\\ Reinforcement \\\\
  d &= ${effectiveHeight}mm \\\\
  A_{s,min,1} &= ${minReinforcement1(beam)}mm^2 \\\\
  A_{s,min,2} &= ${minReinforcement2(beam)}mm^2 \\\\
  A_{s,min} &= ${Math.max(minReinforcement1(beam), minReinforcement2(beam))}mm^2 \\\\
  \\\\
  \\large Requir&\\large ed\\ Reinforcement \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  \\varepsilon_{cu2} &= 0.0035 \\\\
  E_{S} &= 200000 MPa \\\\
  S_{C} &= ${sC} \\\\
  \\xi_{eff} &= ${ksiEffective} \\\\
  \\xi_{eff,lim} &= ${ksiEffectiveLim} \\\\
  ${requiredReinforcement(beam)}
  \\\\
  \\end{aligned}
`}

export function renderResults(beam, node) {
  katexRender(resultsTemplate(beam), node)
}

/*
  \\begin{aligned}
  \\large RC\\ Sec&\\large tion\\ Details \\\\
  h &= ${height}mm \\\\
  b &= ${width}mm \\\\
  c_{nom} &= ${cover}mm \\\\
  \\phi &= ${mainBarDiameter}mm \\\\
  \\phi_{S} &= ${linkDiameter}mm \\\\
  M_{Ed} &= ${bendingMoment}kNm \\\\
  \\large Concre&\\large te\\ Details \\\\
  f_{ck} &= ${concreteClass}MPa \\\\
  \\gamma_C &= ${concreteFactor} \\\\
  \\alpha_{cc} &= 0.85 \\\\
  f_{cd} = \\frac{\\alpha_{cc} * f_{ck}}{\\gamma_C} = \\frac{0.85*${concreteClass}}{${concreteFactor}} &= ${fcd}MPa \\\\
  ${fctmTex(beam)}
  \\large Steel\\ &\\large Details \\\\
  f_{yk} &= ${steelClass}MPa \\\\
  \\gamma_S &= ${steelFactor} \\\\
  f_{yd} &= \\frac{f_{yk}}{\\gamma_S} = \\frac{${steelClass}}{${steelFactor}} = ${fyd}MPa \\\\
  \\large Minim&\\large um\\ Reinforcement \\\\
  d = h - c_{nom} - \\phi_{S} - \\frac{\\phi}{2} = ${height} - ${cover} - ${linkDiameter} - \\frac{${mainBarDiameter}}{2} &= ${effectiveHeight}mm \\\\
  A_{s,min,1} = 0.26*\\frac{f_{ctm}}{f_{yk}}*b*d = 0.26*\\frac{${fctm}}{${steelClass}}*${width}*${effectiveHeight} &= ${minReinforcement1(beam)}mm^2 \\\\
  A_{s,min,2} = 0.0013*b*d = 0.0013*${width}*${effectiveHeight} &= ${minReinforcement2(beam)}mm^2 \\\\
  A_{s,min} = max(A_{s,min,1}, A_{s,min,2}) = max(${minReinforcement1(beam)}, ${minReinforcement2(beam)}) &= ${Math.max(minReinforcement1(beam), minReinforcement2(beam))}mm^2 \\\\
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
*/

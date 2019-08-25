// Styles
require('./assets/styles/main.scss')

// KaTeX
import { renderResults } from './assets/js/katex'

// Elm
const Elm = require('./elm/Main.elm').Elm
const app = Elm.Main.init({})

const elements = {
  fck: document.getElementById('fck'),
  fcm: document.getElementById('fcm'),
  fctm: document.getElementById('fctm'),
  eps2: document.getElementById('eps2'),
  eps3: document.getElementById('eps3'),
  concreteFactor: document.getElementById('concreteFactor'),
  alphacc: document.getElementById('alphacc'),
  fcd: document.getElementById('fcd'),
  fyk: document.getElementById('fyk'),
  steelFactor: document.getElementById('steelFactor'),
  fyd: document.getElementById('fyd'),
  concreteCover: document.getElementById('concreteCover'),
}
app.ports.toJs.subscribe(function (beam) {
  console.log('got from Elm:', beam)
  renderResults(beam, elements)
})

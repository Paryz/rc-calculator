// Styles
require('./assets/styles/main.scss')

// KaTeX
import { renderResults } from './assets/js/katex'

// Elm
import { Elm } from './elm/Main.elm'
const app = Elm.Main.init({})

app.ports.toJs.subscribe(function (beam) {
  console.log('got from Elm:', beam)
  renderResults(beam, document.getElementById('results'))
})

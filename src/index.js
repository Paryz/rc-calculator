// Styles
require('./assets/styles/main.scss')

// KaTeX
import { renderResults } from './assets/js/katex'

// Elm
import { Elm } from './elm/Main.elm'

document.addEventListener("DOMContentLoaded", () => {
  const app = Elm.Main.init({})

  app.ports.toJs.subscribe(beam => {
    window.requestAnimationFrame(() => {
      renderResults(beam, document.getElementById('results'))
    });
  });
});
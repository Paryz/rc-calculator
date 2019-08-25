// Styles
require('./assets/styles/main.scss');

// KaTeX
const katex = require('katex');

function template(beam) {return '\\int_{0}^{' + beam.height + '} x^n dx = \\frac{1}{n+1}'}
function fck(beam) {return `f_{ck} = ${beam.concreteClass}\\frac{N}{mm^2}`}
function fcm(beam) {return `f_{cm} = f_{ck} + 8\\frac{N}{mm^2} = ${parseInt(beam.concreteClass)+8}\\frac{N}{mm^2}`}
// Vendor JS is imported as an entry in webpack.config.js

function katexRender(fun, elem) {
  katex.render(fun, elem, {
    throwOnError: false,
    output: 'html',
    displayMode: true
  });
}
// Elm
var Elm = require('./elm/Main.elm').Elm;
var app = Elm.Main.init({});
var fckElement = document.getElementsByClassName('fck')[0]
var fcmElement = document.getElementsByClassName('fcm')[0]

app.ports.toJs.subscribe(function (beam) {
  console.log('got from Elm:', beam);
  katexRender(fck(beam), fckElement)
  katexRender(fcm(beam), fcmElement)
})

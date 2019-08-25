// Styles
require('./assets/styles/main.scss');

// KaTeX
const katex = require('katex');

function template(beam) {return '\\int_{0}^{' + beam.height + '} x^n dx = \\frac{1}{n+1}'}
// Vendor JS is imported as an entry in webpack.config.js

// Elm
var Elm = require('./elm/Main.elm').Elm;
var app = Elm.Main.init({});
var element = document.getElementById('test')

app.ports.toJs.subscribe(function (beam) {
  console.log('got from Elm:', beam);
  katex.render(template(beam), element, {
    throwOnError: false,
    output: 'html',
    displayMode: true
  });
})

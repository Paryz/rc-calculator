const path = require('path');
const { merge } = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const StyleLintPlugin = require('stylelint-webpack-plugin');

const modeConfig = mode => require(`./build-utils/webpack.${mode}`)(mode);
const presetConfig = require('./build-utils/loadPresets');

module.exports = (env = {}, argv = {}) => {
  const mode = env.mode || argv.mode || 'production';
  const presets = env.presets || [];

  console.log(`Building for: ${mode}`);

  return merge(
    {
      mode,

      entry: {
        main: path.join(__dirname, './src/index.js'),
        vendor: path.join(__dirname, './src/assets/js/vendor.js')
      },

      plugins: [
        new HtmlWebpackPlugin({
          template: 'src/assets/index.html',
          inject: 'body',
          filename: 'index.html'
        }),

        new StyleLintPlugin({
          files: 'src/assets/styles/**/*.scss'
        }),

        new CopyWebpackPlugin({
          patterns: [{ from: 'src/assets/favicon.ico' }]
        })
      ]
    },
    modeConfig(mode),
    presetConfig({ mode, presets })
  );
};

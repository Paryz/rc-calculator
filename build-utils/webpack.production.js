const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const PurgecssPlugin = require('purgecss-webpack-plugin');
const ImageminPlugin = require('imagemin-webpack-plugin').default;
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');

const shouldUseSourceMap = process.env.GENERATE_SOURCEMAP !== 'false';

module.exports = () => ({
  output: {
    filename: '[name].[contenthash].js',
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            optimize: true,
          },
        },
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.(sa|sc|c)ss$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader'],
      },
      { test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' },
    ],
  },

  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        uglifyOptions: {
          // ES5 is required in the minified code if you want compatibility with IE11,
          // otherwise you can bump it up to ES8
          ecma: 5,
          // Compression settings mostly based on <https://guide.elm-lang.org/optimization/asset_size.html>
          compress: {
            passes: 2,
            warnings: false,
            // Disabled because of an issue with Uglify breaking seemingly valid code:
            // https://github.com/facebook/create-react-app/issues/2376
            // Pending further investigation:
            // https://github.com/mishoo/UglifyJS2/issues/2011
            comparisons: false,
            pure_getters: true,
            keep_fargs: false,
            unsafe_comps: true,
            unsafe: true,
            pure_funcs: [
              'A2',
              'A3',
              'A4',
              'A5',
              'A6',
              'A7',
              'A8',
              'A9',
              'F2',
              'F3',
              'F4',
              'F5',
              'F6',
              'F7',
              'F8',
              'F9'
            ]
          },
          mangle: {
            safari10: true
          },
          output: {
            comments: false,
            // Turned on because emoji and regex is not minified properly using default
            // https://github.com/facebook/create-react-app/issues/2488
            ascii_only: true
          }
        },
        // Use multi-process parallel running to improve the build speed
        // Default number of concurrent runs: os.cpus().length - 1
        parallel: true,
        // Enable file caching
        cache: true,
        sourceMap: shouldUseSourceMap
      })
    ],
    // Automatically split vendor and commons
    // https://twitter.com/wSokra/status/969633336732905474
    splitChunks: {
      chunks: 'all'
    },
    // Keep the runtime chunk seperated to enable long term caching
    // https://twitter.com/wSokra/status/969679223278505985
    runtimeChunk: true
  },

  plugins: [
    new MiniCssExtractPlugin({
      filename: 'assets/css/[name].[contenthash].css',
    }),

    new PurgecssPlugin({
      paths: glob.sync(path.join(__dirname, '../src/**/*.elm'), { nodir: true }),
    }),

    new CopyWebpackPlugin([{ from: 'src/assets/images', to: 'assets/images' }]),

    new ImageminPlugin({
      test: /\.(jpe?g|png|gif|svg)$/i,
      cache: true,
    }),

    new OptimizeCSSAssetsPlugin(),
  ],
});

const path = require("path");
const DashboardPlugin = require('webpack-dashboard/plugin');
const webpack = require('webpack');

module.exports = () => ({
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [

          { loader: 'elm-hot-webpack-loader' },
          {
            loader: 'elm-webpack-loader',
            options: {
              cwd: path.join(__dirname, '../'),
              debug: true
            }
          }
        ]
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.s?css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader', 'sass-loader']
      },
      { test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' }
    ]
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),

    new DashboardPlugin(),
  ],

  devServer: {
    contentBase: './src',
    historyApiFallback: true,
    inline: true,
    stats: 'errors-only',
    hot: true,
  }
});

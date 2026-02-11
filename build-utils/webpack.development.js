const path = require("path");

module.exports = () => ({
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
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
        use: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          {
            loader: 'sass-loader',
            options: {
              sassOptions: {
                silenceDeprecations: [ 'import', 'global-builtin', 'color-functions' ]
              }
            }
          }
        ]
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/i,
        type: 'asset',
        parser: {
          dataUrlCondition: {
            maxSize: 100 * 1024
          }
        }
      }
    ]
  },

  devServer: {
    static: {
      directory: path.join(__dirname, '../src')
    },
    historyApiFallback: true,
    hot: true,
    client: {
      overlay: {
        errors: true,
        warnings: false
      }
    }
  }
});

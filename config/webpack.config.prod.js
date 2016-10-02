var path = require("path");
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

const root = process.cwd();

module.exports = {
  bail: true,
  entry: [
      path.resolve('./src/index.js')
  ],
  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },
  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack?pathToMake=node_modules/.bin/elm-make',
      },
      {
        test: /\.(ico|jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2)(\?.*)?$/,
        exclude: /\/favicon.ico$/,
        loader: 'file',
        query: {
          name: 'static/media/[name].[hash:8].[ext]'
        }
      }
    ],
    noParse: /\.elm$/,
  },
  plugins: [
    new CleanWebpackPlugin([ 'dist' ], {
      root: root,
      verbose: true,
      dry: false
    }),

    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      },
      output: {
        comments: false
      }
    }),
    new HtmlWebpackPlugin({
      inject: true,
      template: path.resolve('./src/index.html'),
      favicon: path.resolve('./src/favicon.ico'),
      minify: {
        removeComments: true,
        collapseWhitespace: true,
        removeRedundantAttributes: true,
        useShortDoctype: true,
        removeEmptyAttributes: true,
        removeStyleLinkTypeAttributes: true,
        keepClosingSlash: true,
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true
      }
    })
  ]
};

# git
git init
cat > .gitignore << EOM
node_modules
build
EOM

# npm
npm init
npm install webpack webpack-cli webpack-dev-server html-webpack-plugin babel-loader babel-core babel-preset-env babel-preset-react url-loader style-loader css-loader less-loader less --save-dev
npm install react react-dom prop-types classnames debug babel-polyfill --save

# babel
cat > .babelrc << EOM
{
  "presets": [
    "env",
    "react"
  ]
}
EOM

# webpack config
cat > webpack.config.js << EOM
const path = require("path")
const HtmlWebpackPlugin = require("html-webpack-plugin")

module.exports = {
  entry: "./src/index.js",
  output: {
    filename: "[name].[chunkhash].js",
    path: path.resolve(__dirname, "build")
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      },
      {
        test: /\.less$/,
        use: [
          {
            loader: "style-loader"
          },
          {
            loader: "css-loader",
            options: {
              modules: true,
              localIdentName: "[local]_[hash:base64:5]"
            }
          },
          {
            loader: "less-loader"
          }
        ]
      },
      {
        test: /\.(png|jpg|gif|svg)$/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 8192
            }
          }
        ]
      }
    ]
  },
  devtool: "inline-source-map",
  plugins: [
    new HtmlWebpackPlugin()
  ],
  devServer: {
    open: true
  }
}
EOM

# npm scripts
node -e "$(cat << EOM
const fs = require('fs')
const package = require('./package.json')

package.scripts = package.scripts || {}
package.scripts.build = 'webpack --mode development'
package.scripts.dev = 'webpack-dev-server'

fs.writeFileSync('./package.json', JSON.stringify(package, 0, 2), 'utf8')
EOM
)"

# initial structure
mkdir ./src

cat > ./src/index.js << EOM
import "babel-polyfill"
import React from "react"
import ReactDOM from "react-dom"
import App from "./containers/App"

const root = document.createElement("div")
root.setAttribute("id", "root")
document.body.appendChild(root)

ReactDOM.render(<App />, root)
EOM

mkdir -p ./src/containers/App

cat > ./src/containers/App/style.less << EOM
.container {
  width: 100%;
}
EOM

cat > ./src/containers/App/index.js << EOM
import React, { Component } from "react"
import PropTypes from "prop-types"
import classnames from "classnames/bind"

import style from "./style.less"

const cx = classnames.bind(style)

class App extends Component {
  constructor (props) {
    super(props)
    this.state = {
      message: "hello"
    }
  }

  render () {
    return <div>{this.state.message}</div>
  }
}

App.propTypes = {}

App.displayName = "Containers/App"

export default App
EOM

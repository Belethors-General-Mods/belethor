// load bootstrap
require('bootstrap');
import 'bootstrap/dist/css/bootstrap.min.css';

// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"; // eslint-disable-line no-unused-vars

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import $ from 'jquery';
import Elm from "../elm-src/Main.elm";

let form = $("#elm-form");
if(form.length == 1) {
    Elm.Elm.Main.init({node: form.get()[0]});
}

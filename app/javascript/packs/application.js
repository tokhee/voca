// app/javascript/packs/application.js

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import cocoon from "cocoon-js"

Rails.start()
Turbolinks.start()

const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

console.log("cocoon.js has been loaded.")

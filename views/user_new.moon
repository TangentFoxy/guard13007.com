import Widget from require "lapis.html"

import autoload from require "locator"
import settings from autoload "utility"

class extends Widget
  content: =>
    form {
      action: @url_for "user_new", nil, redirect: @params.redirect
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      p "Username: "
      input type: "text", name: "name", autocomplete: "username"
      p "Email: "
      input type: "email", name: "email"
      p "Password: "
      input type: "password", name: "password"
      br!
      if settings["users.require-recaptcha"]
        div class: "g-recaptcha", "data-sitekey": settings["users.recaptcha-sitekey"]
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"

    if settings["users.require-recaptcha"]
      script src: "https://www.google.com/recaptcha/api.js"

import Widget from require "lapis.html"

class extends Widget
  content: =>
    form {
      action: @url_for "user_login", nil, redirect: @params.redirect
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      text "Username: "
      input type: "text", name: "name"
      br!
      text "Password: "
      input type: "password", name: "password"
      br!
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"

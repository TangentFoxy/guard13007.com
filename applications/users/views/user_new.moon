import Widget from require "lapis.html"

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
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"

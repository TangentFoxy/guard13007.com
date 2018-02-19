import Widget from require "lapis.html"

class extends Widget
  content: =>
    form {
      action: @url_for "user_edit"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      text "Change username? "
      input type: "text", name: "name", value: @user.name
      br!
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"
    hr!

    form {
      action: @url_for "user_edit"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      text "Change email address? "
      input type: "email", name: "email", value: @user.email
      br!
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"
    hr!

    form {
      action: @url_for "user_edit"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      p "Change password?"
      element "table", ->
        tr ->
          td "Old password:"
          td -> input type: "password", name: "oldpassword", autocomplete: "password"
        tr ->
          td "New password:"
          td -> input type: "password", name: "password"
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"
    hr!

    form {
      action: @url_for "user_edit"
      method: "POST"
      enctype: "multipart/form-data"
      onsubmit: "return confirm('Are you sure you want to do this?');"
    }, ->
      text "Delete user? "
      input type: "checkbox", name: "delete"
      br!
      input type: "hidden", name: "csrf_token", value: @csrf_token
      input type: "submit"

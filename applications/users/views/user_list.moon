import Widget from require "lapis.html"

class extends Widget
  content: =>
    p "#{#@users} users."
    element "table", ->
      thead ->
        tr ->
          th "ID"
          th "Admin"
          th "Username"
          th "Email Address"
      tbody ->
        for user in *@users
          tr ->
            td user.id
            if user.admin
              td "✔"
            else
              td! -- "❌"
            td user.name
            td user.email
      tfoot ->
        tr ->
          th "ID"
          th "Admin"
          th "Username"
          th "Email Address"

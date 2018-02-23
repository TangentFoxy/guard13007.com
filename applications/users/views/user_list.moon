import Widget from require "lapis.html"

class extends Widget
  content: =>
    p "#{#@users} users."
    element "table", ->
      thead ->
        tr ->
          th "ID"
          th "Username"
          th "Email Address"
          th "Admin"
      tbody ->
        for user in *@users
          tr ->
            td user.id
            td user.name
            td user.email
            if user.admin
              td "✔"
            else
              td! -- "❌"
      tfoot ->
        tr ->
          th "ID"
          th "Username"
          th "Email Address"
          th "Admin"

import Widget from require "lapis.html"

class Error404 extends Widget
  content: =>
    div class: "container has-text-centered", ->
      p "That means you followed a broken link. :/"
      p ->
        text "(Feel like this is a mistake? Please "
        a href: "/contact", "contact"
        text " me!)"

import Widget from require "lapis.html"

class extends Widget
  content: =>
    h3 class: "subtitle", ->
      a href: @url_for("polls_index"), "Back to Polls"
    div class: "level", ->
      div class: "level-item", ->
        iframe src: @poll, style: "width:600px;height:390px;border:0;", "Loading poll..."

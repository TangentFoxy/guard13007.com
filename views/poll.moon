import Widget from require "lapis.html"

class extends Widget
  content: =>
    div class: "level", ->
      div class: "level-item", ->
        iframe src: @poll, style: "width:600px;height:390px;border:0;", "Loading poll..."

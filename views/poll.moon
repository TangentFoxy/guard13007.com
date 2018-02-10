import Widget from require "lapis.html"

class extends Widget
  content: =>
    link rel: "stylesheet", href:  "/static/css/poll.css"
    div class: "return", ->
      h3 -> a href: @url_for("polls_index"), "Back to Polls"
    div class: "poll", ->
      iframe src: @poll, "Loading poll..."

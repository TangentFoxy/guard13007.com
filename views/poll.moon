import Widget from require "lapis.html"

class extends Widget
    content: =>
        link rel: "stylesheet", href: @build_url "static/css/poll.css"
        div class: "return", ->
            h3 -> a href: @url_for("polls"), "Back to Polls"
        div class: "poll", ->
            iframe src: @poll, "Loading poll..."

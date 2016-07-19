import Widget from require "lapis.html"

class extends Widget
    content: =>
        h1 "Welcome"
        p ->
            text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
            a href: @build_url("map.html"), "here's a link"
            text " to my old site map."

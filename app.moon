lapis = require "lapis"

import respond_to from require "lapis.application"

class extends lapis.Application
    [update: "/update"]: respond_to {
        GET: =>
            return status: 404
        POST: =>
            os.execute("git pull origin")
            os.execute("moonc .")
            os.execute("lapis migrate production")
            os.execute("lapis build production")
            return status: 200
    }

    "/": =>
        @html ->
            p ->
                text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
                a href: @build_url("map.html"), "here's a link"
                text " to my old site map."

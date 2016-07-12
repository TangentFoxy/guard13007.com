lapis = require "lapis"

import respond_to from require "lapis.application"

class extends lapis.Application
    [update: "/update"]: respond_to {
        GET: =>
            -- do fuck all
        POST: =>
            print "all the shit!"
            --and then actually run commands
            os.execute("pwd > /root/file")
    }

    "/": =>
        @html ->
            p ->
                text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
                a href: @build_url("map.html"), "here's a link"
                text " to my old site map."

lapis = require "lapis"

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @include "redirects"
    @include "misc"

    [update: "/update"]: respond_to {
        GET: =>
            return status: 404
        POST: json_params =>
            if @params.ref == "refs/heads/master"
                os.execute "echo \"Updating server...\" >> logs/updates.log"
                os.execute "git pull origin >> logs/updates.log"
                os.execute "moonc . >> logs/updates.log" -- NOTE this doesn't actually work, figure out correct stream to output to file
                os.execute "lapis migrate production >> logs/updates.log"
                os.execute "lapis build production >> logs/updates.log"
                return { json: { status: "successful" } } -- yes, I know this doesn't actually check if it was successful yet
            else
                return { json: { status: "ignored non-master push" } }
    }

    "/": =>
        @html ->
            p ->
                text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
                a href: @build_url("map.html"), "here's a link"
                text " to my old site map."

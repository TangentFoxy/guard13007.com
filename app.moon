lapis = require "lapis"

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @include "ksp"
    @include "redirects"
    @include "misc"

    [githook: "/githook"]: respond_to {
        GET: =>
            return status: 404
        POST: json_params =>
            if @params.ref == "refs/heads/master"
                os.execute "echo \"Updating server...\" >> logs/updates.log"
                os.execute "git pull origin >> logs/updates.log"
                os.execute "moonc . 2>> logs/updates.log"
                os.execute "lapis migrate production >> logs/updates.log"
                os.execute "lapis build production >> logs/updates.log"
                return { json: { status: "successful" } } --TODO scan for actual success (exit codes?), return a server error or whatever for errors
            else
                return { json: { status: "ignored non-master push" } }
    }

    [index: "/"]: =>
        render: true

lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @include "ksp"
    @include "redirects"
    @include "misc"

    [githook: "/githook"]: respond_to {
        GET: =>
            return status: 405 --Method Not Allowed

        POST: json_params =>
            unless config.githook
                return status: 401 --Unauthorized

            if @params.ref == nil
                return { json: { status: "invalid request" } }, status: 400 --Bad Request

            if @params.ref == "refs/heads/master"
                os.execute "echo \"Updating server...\" >> logs/updates.log"
                result = 0 == os.execute "git pull origin >> logs/updates.log"
                result and= 0 == os.execute "git submodule init >> logs/updates.log"
                result and= 0 == os.execute "git submodule update >> logs/updates.log"
                result and= 0 == os.execute "moonc . 2>> logs/updates.log"
                result and= 0 == os.execute "lapis migrate production >> logs/updates.log"
                result and= 0 == os.execute "lapis build production >> logs/updates.log"
                if result
                    return { json: { status: "successful", message: "server updated to latest version" } }
                else
                    return { json: { status: "failure", message: "check logs/updates.log"} }, status: 500 --Internal Server Error
            else
                return { json: { status: "successful", message: "ignored non-master push" } }
    }

    [index: "/"]: =>
        render: true

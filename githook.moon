lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"
import hmac_sha1 from require "lapis.util.encoding"

const_compare = (string1, string2) ->
    local fail, dummy

    for i = 1, 100
        if string1\sub(i,i) ~= string2\sub(i,i)
            fail = true
        else
            dummy = true -- making execution time equal

    return not fail

hex_dump = (str) ->
    len = string.len str
    hex = ""

    for i = 1, len
        hex ..= string.format( "%02x", string.byte( str, i ) )

    return hex

class extends lapis.Application
    [githook: "/githook"]: respond_to {
        GET: =>
            return status: 405, "Method Not Allowed"

        POST: json_params =>
            unless config.githook
                return status: 401, "Unauthorized"

            local branch
            if type(config.githook) == "string"
                branch = config.githook
            else
                branch = "master"

            if config.githook_secret
                ngx.req.read_body!
                unless const_compare ("sha1=" .. hex_dump hmac_sha1(config.githook_secret, ngx.req.get_body_data!)), @req.headers["X-Hub-Signature"]
                    return { json: { status: "invalid request" } }, status: 400 --Bad Request

            elseif @params.ref == nil -- fallback to old version for apps that aren't updated to proper verification!
                return { json: { status: "invalid request" } }, status: 400 --Bad Request

            if @params.ref == "refs/heads/#{branch}"
                os.execute "echo \"Updating server...\" >> logs/updates.log"
                result = 0 == os.execute "git checkout #{branch} >> logs/updates.log"
                result and= 0 == os.execute "git pull origin >> logs/updates.log"
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
                return { json: { status: "successful", message: "ignored push (looking for #{branch})" } }
    }

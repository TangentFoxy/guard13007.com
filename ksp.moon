lapis = require "lapis"

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @path: "/ksp"
    @name: "ksp_"
    [submit_planes: "/submit"]: respond_to {
        GET: =>
            @html ->
                form {
                    action: @url_for "ksp_submit_planes" --this might break!
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    p "Stuff"
                    input type: "text", name: "stuff"

        POST: json_params =>
            -- process input, place in database
    }

    --[plane_list: "/planes(/:page[%d])"]: =>
        -- do stuff! @params.page

lapis = require "lapis"

import respond_to from require "lapis.application"

Colors = require "models.Colors"

class extends lapis.Application
    @path: "/colors"
    @name: "colors_"

    [index: ""]: =>
        return layout: "simple", @html ->
            p "Some rendering."

    -- id, code
    --[colors_add: "/colors/add/:hex[a-fA-F%d]"]: =>
    --    @params.hex

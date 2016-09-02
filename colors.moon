lapis = require "lapis"

import respond_to from require "lapis.application"

Colors = require "models.Colors"

class extends lapis.Application
    @path: "/colors"
    @name: "colors_"

    [hex: "(/:hex[a-fA-F%d])"]: respond_to {
        GET: =>
            if @params.hex
                @hex = @params.hex\sub 1, 6 -- TODO check me
            else
                @hex = "FFFFFF"

            render: "color", layout: "simple"

        POST: =>
            if @params.code == @params.name
                return redirect_to: @url_for "colors_hex", @params.code

            color = Colors\create {
                name: @params.name
                code: @params.code
            }

            return redirect_to: @url_for "colors_named", @params.name
    }

    [named: "/:name"]: =>
        if color = Colors\find name: @params.name
            @hex = color.code
            return render: "color", layout: "simple"
        else
            return redirect_to: @url_for "colors_hex"

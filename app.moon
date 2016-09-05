lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @before_filter =>
        str = ""
        for key, value in pairs @req.parsed_url
            str ..= "\n#{key} = #{value}"
        return str

        --@redirect = @req.parsed_url
        --if @session.info
        --    @info = @session.info
        --    @session.info = nil

    layout: "default"

    @include "githook/githook"
    @include "users/users"
    @include "ksp"
    @include "polls"
    @include "redirects"
    @include "testing"
    @include "misc"
    @include "blog"

    [index: "/"]: =>
        render: true

    "/submit": => redirect_to: @url_for "ksp_submit_crafts"

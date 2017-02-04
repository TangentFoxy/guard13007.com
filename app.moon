lapis = require "lapis"

class extends lapis.Application
    @before_filter =>
        u = @req.parsed_url
        if u.path != "/users/login"
            @session.redirect = "#{u.scheme}://#{u.host}#{u.path}"
        if @session.info
            @info = @session.info
            @session.info = nil

    layout: "default"

    @include "githook/githook"
    @include "users/users"
    @include "contact"
    @include "ksp"
    @include "redirects"
    @include "polls"
    @include "blog"
    @include "1000cards"
    @include "misc"
    @include "testing"
    @include "john"
    @include "greyout"

    [index: "/"]: =>
        render: true

    "/submit": => redirect_to: @url_for "ksp_submit_crafts"

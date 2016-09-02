lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    layout: "default"

    @include "githook/githook"
    @include "users/users"
    @include "ksp"
    @include "polls"
    @include "redirects"
    @include "testing"
    @include "misc"
    @include "blog"
    @include "colors"

    [index: "/"]: =>
        render: true

    "/submit": => redirect_to: @url_for "ksp_submit_crafts"

lapis = require "lapis"

class extends lapis.Application
  @before_filter =>
    u = @req.parsed_url
    if u.path != @url_for "user_login"
      @session.redirect = u.path
    if @session.info
      @info = @session.info
      @session.info = nil

  layout: "default2" -- TODO replace original when ready

  @include "applications.posts"

  @include "githook"
  @include "users/users"
  @include "contact"
  @include "ksp"
  @include "redirects"
  @include "polls"
  @include "blog"
  @include "keys"
  @include "misc"
  @include "1000cards"
  @include "testing"
  @include "john"
  @include "greyout"

  [index: "/"]: =>
    render: true

  "/submit": => redirect_to: @url_for "ksp_submit_crafts"

  -- TODO this will return a post if one exists at that custom url, else 404
  -- TODO make this work by just returning the render directive for a post
  -- "/*": =>
  --   return @params.splat

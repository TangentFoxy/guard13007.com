lapis = require "lapis"

import Posts from require "models"

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

  "/*": =>
    if @post = Posts\find splat: @params.splat
      @title = @post.title
      return render: "posts.view"
    else
      return status: 404 -- TODO write better error page

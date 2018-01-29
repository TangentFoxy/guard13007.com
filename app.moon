lapis = require "lapis"

import Posts from require "models"
import default from require "layouts"

class extends lapis.Application
  @before_filter =>
    u = @req.parsed_url
    if u.path != @url_for "user_login"
      @session.redirect = u.path
    if @session.info
      @info = @session.info
      @session.info = nil

  layout: default

  handle_404: =>
    @title = "404 - Not Found"
    return render: "404", status: 404 -- status should not be needed ?

  @include "applications.posts"
  @include "applications.githook.init"
  @include "applications.redirects"
  @include "applications.ksp_crafts"

  @include "users/users"
  @include "polls"
  @include "keys"
  @include "1000cards"
  @include "john"
  @include "greyout"

  [index: "/"]: =>
    return render: true

  [posts_splat: "/*"]: =>
    if @post = Posts\find splat: @params.splat
      @title = @post.title
      return render: "posts.view", content_type: "text/html; charset=utf-8"
    else
      -- return @default_route(@)
      @title = "404 - Not Found"
      return render: "404", status: 404

  -- Legacy redirects
  "/submit": => redirect_to: @url_for "ksp_submit_crafts"
  "/ksp/*": => redirect_to: "/gaming/ksp/#{@params.splat}", status: 302

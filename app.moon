lapis = require "lapis"
console = require "lapis.console"

import Posts from require "models"
import respond_to from require "lapis.application"
import autoload, locate, registry from require "locator"
import bare, default from autoload "layouts"
import settings from autoload "utility"

class extends lapis.Application
  @before_filter =>
    settings.load!
    registry.before_filter(@)
    if @session.info
      @info = @session.info
      @session.info = nil

  layout: default

  @include locate "githook"
  @include locate "users"
  @include locate "posts"
  @include locate "ksp_crafts"
  @include locate "polls"

  @include locate "redirects"

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
      @app.handle_404(@)

  [console: "/console"]: =>
    if @user and @user.admin
      return console.make(env: "all")(@)
    else
      return status: 401, "401 - Unauthorized"

  handle_404: =>
    @title = "404 - Not Found"
    return render: "404", status: 404 -- status should not be needed ?

  [links: "/links"]: =>
    @title = "Links 2 Stuff"
    return layout: bare, render: "true"

  -- Legacy redirects
  "/submit": => redirect_to: @url_for "ksp_submit_crafts"
  "/ksp/*": => redirect_to: "/gaming/ksp/#{@params.splat}", status: 302 -- not functioning :/

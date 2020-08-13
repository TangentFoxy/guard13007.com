lapis = require "lapis"
console = require "lapis.console"

import Posts from require "models"
import respond_to from require "lapis.application"
import bare, default from require "layouts"
import settings from require "utility"

class MainApp extends lapis.Application
  @before_filter =>
    settings.load!
    @user = Sessions\get(@session)
    if @session.info
      @info = @session.info
      @session.info = nil

  layout: default

  @include "applications.users"
  @include "applications.posts"
  @include "applications.videos"
  @include "applications.ksp_crafts"
  @include "applications.keys"
  @include "applications.polls"
  @include "applications.redirects"

  @include "1000cards" -- TODO rewrite and replace

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
    return layout: bare, render: true

  -- legacy redirects
  [ksp_redirect: "/ksp/*"]: => redirect_to: "/gaming/ksp/#{@params.splat}", status: 302
  "/submit": => redirect_to: @url_for "ksp_crafts_submit"

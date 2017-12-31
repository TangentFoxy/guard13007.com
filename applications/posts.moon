lapis = require "lapis"

import Posts from require "models"
import respond_to from require "lapis.application"
import is_admin from require "utility.auth"

class extends lapis.Application
  @path: "/post"
  @name: "posts_"

  [index: "s(/:page[%d])"]: =>
    return "Temporarily out of order."

  [new: "/new"]: respond_to {
    before: =>
      unless is_admin @ return redirect_to: @url_for "posts_index"
    GET: =>
      @title = "New Post"
      render: "posts.new"
    POST: =>
      return "Not implemented."
  }

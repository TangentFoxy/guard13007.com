lapis = require "lapis"

class extends lapis.Application
  @before_filter =>
    -- TODO instead of storing a redirect non-sense, have any URL to login page INCLUDE a redirect value in the GET
    u = @req.parsed_url
    if u.path != @url_for "user_login"
      @session.redirect = u.path
    if @session.info
      @info = @session.info
      @session.info = nil

  @include "applications.githook.init"
  @include "applications.cron"

  "/": =>
    "Welcome to Lapis #{require "lapis.version"}!"

Twitter = require("twitter").Twitter

import TwitterTokens from require "models"
import autoload from require "locator"
import settings from autoload "utility"

advertise_post = (user_id, post) ->
  if settings["twitter-oauth.consumer_key"] and settings["twitter-oauth.consumer_secret"]
    if token = TwitterTokens\find :user_id
      if client = Twitter {
        access_token: token.access_token
        access_token_secret: token.access_token_secret
        consumer_key: settings["twitter-oauth.consumer_key"]
        consumer_secret: settings["twitter-oauth.consumer_secret"]
      }
        -- TODO use post.title and url_for to generate a url w slug or splat
        -- TODO I need to have domain stored somewhere accessible
        return client\post_status status: "I posted a thing called '#{post.title}' @ https://guard13007.com/posts"

  return false

{
  :advertise_post
}

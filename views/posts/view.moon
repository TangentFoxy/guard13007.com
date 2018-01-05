import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"

class ViewPost extends Widget
  content: =>
    div class: "container has-text-centered", ->
      h2 class: "subtitle", "Published #{time_ago_in_words @post.published_at, 2}, last modified #{time_ago_in_words @post.updated_at, 2}"
    div class: "content", ->
      raw @post.html

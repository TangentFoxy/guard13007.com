import Widget from require "lapis.html"
import Pagination from require "widgets"
import locate from require "locator"
import pretty_date from require "datetime"

class PostIndex extends Widget
  content: =>
    widget Pagination

    for post in *@posts
      div class: "content", ->
        h2 post.title
        raw post.preview_html
        h3 class: "subtitle is-6", ->
          if post.splat
            a href: "/#{post.splat}", "Read More"
          else
            a href: @url_for("posts_view", slug: post.slug), "Read More"
          text ". Published: #{pretty_date post.published_at}. "
          span class: "disqus-comment-count", "data-disqus-identifier": "https://guard13007.com#{@url_for "posts_view", slug: post.slug}"
          if @user and @user.admin
            text " "
            a href: @url_for("posts_edit", id: post.id), "Edit Post"

    widget Pagination

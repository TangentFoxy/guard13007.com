import Widget from require "lapis.html"
import Posts from require "models"
import Pagination from require "widgets"

class PostIndex extends Widget
  content: =>
    widget Pagination

    table class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      thead ->
        tr ->
          th "ID"
          th "Title"
          th "Status"
          th "Type"
          th "Updated"
          th "Created"
          th "View"
          th "Edit"
          th "Comments"
      tbody ->
        for post in *@posts
          tr ->
            td post.id
            td post.title
            td Posts.statuses\to_name post.status
            td Posts.types\to_name post.type
            td post.updated_at
            td post.created_at
            td -> a class: "button", href: @url_for("posts_view", slug: post.slug), "View"
            td -> a class: "button", href: @url_for("posts_edit", id: post.id), "Edit"
            td -> span class: "disqus-comment-count", "data-disqus-identifier": "https://guard13007.com#{@url_for "posts_view", slug: post.slug}"

    widget Pagination

import Widget from require "lapis.html"
import Posts from require "models"
import Pagination from require "widgets"

class PostIndex extends Widget
  content: =>
    widget Pagination

    element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      thead ->
        tr ->
          th "ID"
          th "Title"
          th "Status"
          th "Type"
          th "Updated"
          th "Created"
          th "View/Edit/Delete"
          th "Comments"
      tfoot ->
        tr ->
          th "ID"
          th "Title"
          th "Status"
          th "Type"
          th "Updated"
          th "Created"
          th "View/Edit/Delete"
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
            td -> div class: "buttons", ->
              a class: "button", href: @url_for("posts_view", slug: post.slug), "View"
              a class: "button", href: @url_for("posts_edit", id: post.id), "Edit"
              a class: "button", href: @url_for("posts_delete", id: post.id), onclick: "return confirm('Are you sure you want to delete this post?');", "Delete"
            td -> span class: "disqus-comment-count", "data-disqus-identifier": "https://guard13007.com#{@url_for "posts_view", slug: post.slug}"

    div class: "container has-text-centered", ->
      a class: "button", href: @url_for("posts_new"), "New Post"

    widget Pagination

import Widget from require "lapis.html"

class Pagination extends Widget
  content: =>
    nav class: "pagination is-centered", ->
      if @page == 1
        a class: "pagination-previous", disabled: true, @previous_label or "Previous"
      else
        a class: "pagination-previous", href: @url_for("posts_index", page: 1), @previous_label or "Previous"

      if @page == @last_page
        a class: "pagination-next", disabled: true, @next_label or "Next"
      else
        a class: "pagination-next", href: @url_for("posts_index", page: @last_page), @next_label or "Next"

      -- ul class: "pagination-list", ->
      --   if @page > 1
      --     li -> a class: "pagination-link", href: @url_for("posts_index", page: @page - 1), @page - 1
      --   li -> a class: "pagination-link is-current", @page
      --   if @page < @last_page
      --     li -> a class: "pagination-link", href: @url_for("posts_index", page: @page + 1), @page + 1

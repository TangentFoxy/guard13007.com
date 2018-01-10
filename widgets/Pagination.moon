import Widget from require "lapis.html"

class Pagination extends Widget
  content: =>
    nav class: "pagination is-centered", ->
      ul class: "pagination-list", ->
        if @page > 2
          li -> a class: "pagination-link", href: @url_for(@route_name, page: 1), 1
        if @page > 3
          li -> span class: "pagination-ellipsis", "…"
        if @page > 1
          li -> a class: "pagination-link", href: @url_for(@route_name, page: @page - 1), @page - 1
        li -> a class: "pagination-link is-current", @page
        if @page < @last_page
          li -> a class: "pagination-link", href: @url_for(@route_name, page: @page + 1), @page + 1
        if @page < @last_page - 2
          li -> span class: "pagination-ellipsis", "…"
        if @page < @last_page - 1
          li -> a class: "pagination-link", href: @url_for(@route_name, page: @last_page), @last_page

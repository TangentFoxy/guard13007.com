import Widget from require "lapis.html"
import shallow_copy from require "utility.gtable"

class Pagination extends Widget
  content: =>
    element "table", ->
      if @page > 2
        td -> a href: @url_for(@route_name, shallow_copy @page_arguments, page: 1), 1
      if @page > 3
        td -> span "…"
      if @page > 1
        td -> a href: @url_for(@route_name, shallow_copy @page_arguments, page: @page - 1), @page - 1
      td -> a @page
      if @page < @last_page
        td -> a href: @url_for(@route_name, shallow_copy @page_arguments, page: @page + 1), @page + 1
      if @page < @last_page - 2
        td -> span "…"
      if @page < @last_page - 1
        td -> a href: @url_for(@route_name, shallow_copy @page_arguments, page: @last_page), @last_page

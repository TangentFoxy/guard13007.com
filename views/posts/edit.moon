import Widget from require "lapis.html"
import Posts from require "models"
import slugify from require "lapis.util"

class EditPost extends Widget
  content: =>
    link rel: "stylesheet", href: "/static/simplemde/simplemde.min.css"
    script src: "/static/simplemde/simplemde.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script src: "/static/js/marked.min.js"
    script src: "/static/js/jquery-3.1.0.min.js"
    script src: "/static/js/posts/edit.js"
    local action
    if @post
      action = @url_for "posts_edit", id: @post.id
    else
      action = @url_for "posts_new"
      @post = {}
    form {
      :action
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      div class: "field is-grouped is-grouped-centered", ->
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "title", id: "title", placeholder: "Title", value: @post.title
        div class: "control is-expanded", ->
          if @post.slug and @post.slug != slugify @post.title
            input class: "input", type: "text", name: "slug", id: "slug", placeholder: @post.slug, value: @post.slug
          else
            input class: "input", type: "text", name: "slug", id: "slug", placeholder: @post.slug
      div class: "field", ->
        div class: "control", ->
          textarea class: "textarea", rows: 13, name: "text", id: "text", placeholder: "Write here...", @post.text
        div class: "control", ->
          if @post.preview_text and @post.preview_text != @post.text\sub 1, 500
            textarea class: "textarea", rows: 4, name: "preview_text", id: "preview_text", placeholder: @post.preview_text, @post.preview_text
          else
            textarea class: "textarea", rows: 4, name: "preview_text", id: "preview_text", placeholder: @post.preview_text
      div class: "tile is-ancestor is-parent", ->
        div class: "tile is-child is-half", ->
          div class: "field is-horizontal", ->
            div class: "field-label", ->
              label class: "label", for: "type", "Type"
            div class: "field-body", ->
              div class: "field", ->
                div class: "control", ->
                  if @post.type
                    element "select", class: "select", name: "type", id: "type", ->
                      if @post.type == 0 -- hardcoded :\
                        option value: 0, selected: true, "undefined"
                      else
                        option value: 0, "undefined"
                      for ptype in *Posts.types
                        if @post.type == Posts.types[ptype]
                          option value: Posts.types[ptype], selected: true, ptype
                        else
                          option value: Posts.types[ptype], ptype
                  else
                    element "select", class: "select", name: "type", id: "type", ->
                      option value: 0, selected: true, "undefined" -- hardcoded :\
                      for ptype in *Posts.types
                        option value: Posts.types[ptype], ptype
              div class: "field", ->
                div class: "control", ->
                  if @post.splat
                    input class: "input", type: "text", name: "splat", id: "splat", placeholder: "splat", value: @post.splat
                  else
                    input class: "input is-invisible", type: "text", name: "splat", id: "splat", placeholder: "splat"
        div class: "tile is-child is-half", ->
          div class: "field is-horizontal", ->
            div class: "field-label", ->
              label class: "label", for: "status", "Status"
            div class: "field-body", ->
              div class: "field", ->
                div class: "control", ->
                  if @post.status
                    element "select", class: "select", name: "status", id: "status", ->
                      for status in *Posts.statuses
                        if @post.status == Posts.statuses[status]
                          option value: Posts.statuses[status], selected: true, status
                        else
                          option value: Posts.statuses[status], status
                  else
                    element "select", class: "select", name: "status", id: "status", ->
                      for status in *Posts.statuses
                        if status == Posts.statuses.draft
                          option value: Posts.statuses[status], selected: true, status
                        else
                          option value: Posts.statuses[status], status
              div class: "field", ->
                div class: "control", ->
                  if @post.status == Posts.statuses.scheduled
                    input class: "input", type: "text", name: "published_at", id: "published_at", placeholder: "1970-01-01 00:00:00", value: @post.published_at
                  else
                    input class: "input is-invisible", type: "text", name: "published_at", id: "published_at", placeholder: "1970-01-01 00:00:00"
      div class: "control", ->
        div class: "buttons is-centered", ->
          if @post.text
            input class: "button", type: "submit", value: "Update"
          else
            input class: "button", type: "submit", value: "Create"
          input type: "hidden", name: "html", id: "html", value: @post.html
          input type: "hidden", name: "preview_html", id: "preview_html", value: @post.preview_html
    -- TEMPORARY
    if @post
      hr!
      dl ->
        for k,v in pairs @post
          dt -> text k
          dd -> text v

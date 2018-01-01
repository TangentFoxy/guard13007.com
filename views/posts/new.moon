import Widget from require "lapis.html"
import Posts from require "models"

class NewPost extends Widget
  content: =>
    link rel: "stylesheet", href: "/static/simplemde/simplemde.min.css"
    script src: "/static/simplemde/simplemde.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script src: "/static/js/jquery-3.1.0.min.js"
    script src: "/static/js/posts/new.js"
    form {
      action: @url_for "posts_new"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      div class: "field is-grouped is-grouped-centered", ->
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "title", id: "title", placeholder: "Title"
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "slug", id: "slug", placeholder: "title"
      div class: "field", ->
        div class: "control", ->
          textarea class: "textarea", rows: 13, name: "text", placeholder: "Write here..."
        div class: "control", ->
          textarea class: "textarea", rows: 4, name: "preview_text", placeholder: "Preview text."
      div class: "tile is-ancestor is-parent", ->
        div class: "tile is-child is-half", ->
          div class: "field is-horizontal", ->
            div class: "field-label", ->
              label class: "label", for: "type", "Type"
            div class: "field-body", ->
              div class: "field", ->
                div class: "control", ->
                  element "select", class: "select", name: "type", id: "type", ->
                    option value: 0, selected: true, "undefined"
                    for ptype in *Posts.types
                      option value: Posts.types[ptype], ptype
              div class: "field", ->
                div class: "control is-invisible", ->
                  input class: "input", type: "text", name: "splat", id: "splat", placeholder: "splat"
        div class: "tile is-child is-half", ->
          div class: "field is-horizontal", ->
            div class: "field-label", ->
              label class: "label", for: "status", "Status"
            div class: "field-body", ->
              div class: "field", ->
                div class: "control", ->
                  element "select", class: "select", name: "status", ->
                    for status in *Posts.statuses
                      if status == Posts.statuses.draft
                        option value: Posts.statuses[status], selected: true, status
                      else
                        option value: Posts.statuses[status], status
              div class: "field", ->
                div class: "control is-invisible", ->
                  input class: "input", type: "text", name: "published_at", id: "published_at", placeholder: "1970-01-01 00:00:00"
      div class: "control", ->
        div class: "buttons is-centered", ->
          input class: "button", type: "submit", value: "Create"

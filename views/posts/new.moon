import Widget from require "lapis.html"
import Posts from require "models"

class NewPost extends Widget
  content: =>
    link rel: "stylesheet", href: "/static/simplemde/simplemde.min.css"
    script src: "/static/simplemde/simplemde.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script -> raw "
      window.onload = function () {
        var simplemde = new SimpleMDE({
          autosave: {
            enabled: true,
            uniqueId: '#{@url_for "posts_new"}'
          },
          indentWithTabs: false,
          insertTexts: {
            link: ['[', '](https://)']
          },
          parsingConfig: {
            strikethrough: false
          },
          renderingConfig: {
            singleLineBreaks: false,
            codeSyntaxHighlighting: true // uses highlight.js
          }
        });
      }
    "
    form {
      action: @url_for "posts_new"
      method: "POST"
      enctype: "multipart/form-data"
      class: "pure-form pure-g"
    }, ->
      div class: "pure-u-1-4"
      div class: "pure-u-1-2", ->
        input class: "pure-input-1", type: "text", name: "title", placeholder: "Title"
      div class: "pure-u-1-4"

      div class: "pure-u-1-3"
      div class: "pure-u-1-3", ->
        input class: "pure-input-1", type: "text", name: "slug", placeholder: "title-slug"
      div class: "pure-u-1-3"

      div ->
        textarea rows: 13, name: "text", placeholder: "Write here..."
      -- br!
      -- div class: "center", ->
        textarea rows: 4, name: "preview_text", placeholder: "Preview text..."
      -- div class: "center", ->
      -- fieldset class: "pure-group", ->
        label for: "type", "Type: "
        element "select", name: "type", ->
          option value: 0, selected: true, "undefined"
          for ptype in *Posts.types
            option value: Posts.types[ptype], ptype
        label for: "status", "Status: "
        element "select", name: "status", ->
          for status in *Posts.statuses
            if status == Posts.statuses.draft
              option value: Posts.statuses[status], selected: true, status
            else
              option value: Posts.statuses[status], status
        input class: "pure-button", type: "submit", value: "Create"
      -- a class: "pure-button", href: @url_for("blog_drafts"), "Drafts"

      -- {"url", types.text null: true}
      --
      -- {"type", types.integer default: 0}
      --
      -- {"published_at", types.time}
      -- {"created_at", types.time}
      -- {"updated_at", types.time}

import Widget from require "lapis.html"

class KSPCraftsSearchWidget extends Widget
  content: =>
    form {
        action: @url_for "ksp_crafts_search"
        method: "GET"
        -- style: "display: inline-block;"
    }, ->
      div class: "field has-addons", ->
        div class: "control", ->
          input class: "input", type: "text", name: "name", placeholder: "Search for Craft", value: @params.name
        -- div class: "control", ->
        --   input class: "input", type: "text", name: "tags", placeholder: "Tags"
        div class: "control", ->
          input class: "input", type: "text", name: "version", placeholder: "KSP version?", value: @params.version
        div class: "control", ->
        input class: "button", type: "submit", value: "Search"

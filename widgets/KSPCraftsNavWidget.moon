import Widget from require "lapis.html"

class KSPCraftsNavWidget extends Widget
  content: =>
    form {
        action: @url_for "ksp_crafts_search"
        method: "GET"
    }, ->
      div class: "field has-addons", ->
        div class: "control", ->
          a class: "button", href: @url_for("ksp_crafts_index"), "View submitted crafts"
        div class: "control", ->
          a class: "button", href: @url_for("ksp_crafts_submit"), "Submit a craft!"
        div class: "control", ->
          a class: "button", href: @url_for("ksp_crafts_random"), "Random craft"

        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "query", placeholder: "Search for Craft", value: @params.query
        div class: "control", ->
          input class: "input", type: "text", name: "version", placeholder: "KSP version?", value: @params.version
        div class: "control", ->
        input class: "button", type: "submit", value: "Search"

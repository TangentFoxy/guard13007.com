import Widget from require "lapis.html"
import autoload from require "locator"
import KSPCraftsNavWidget from autoload "widgets"
import settings from autoload "utility"

class KSPCraftsSubmit extends Widget
  content: =>
    widget KSPCraftsNavWidget

    link rel: "stylesheet", href: "/static/simplemde/simplemde.min.css"
    script src: "/static/simplemde/simplemde.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script -> raw "
      window.onload = function () { var simplemde = new SimpleMDE({
        autosave: {
          enabled: true,
          uniqueId: '#{@url_for "ksp_crafts_submit"}'
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
          codeSyntaxHighlighting: true
        }
      }); }
    "
    p ->
      text "(If your craft is on "
      a href: "https://kerbalx.com/", "KerbalX"
      text ", you only need to enter the craft name and a link to the craft on KerbalX.)"
    p "Please check your craft links after submission, multiple people have submitted invalid links previously."
    form {
      action: @url_for "ksp_crafts_submit"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      div class: "field is-grouped is-grouped-centered", ->
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "name", placeholder: "Craft Name"
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "download_link", placeholder: "Craft Link"
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "creator", placeholder: "Creator Name"

      div class: "field", ->
        div class: "control", ->
          textarea class: "textarea", rows: 8, name: "description", placeholder: "Description"
        div class: "control", ->
          textarea class: "textarea", rows: 2, cols: 60, name: "action_groups", placeholder: "Action Groups"

      div class: "field is-grouped is-grouped-centered", ->
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "ksp_version", placeholder: "KSP Version"
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "mods_used", placeholder: "Mods Used"
        div class: "control is-expanded", ->
          input class: "input", type: "text", name: "picture", placeholder: "Image URL"

      unless @user
        div class: "level", ->
          div class: "level-item", ->
            div class: "g-recaptcha", "data-sitekey": settings["users.recaptcha-sitekey"]

      div class: "control", ->
        div class: "buttons is-centered", ->
          input class: "button", type: "submit", value: "Submit Craft"

      unless @user
        script src: "https://www.google.com/recaptcha/api.js"

import Widget from require "lapis.html"

import GameKeys from require "models"
import autoload from require "locator"
import GameKeysMenu from autoload "widgets"

class extends Widget
  content: =>
    widget GameKeysMenu

    form {
      action: @url_for "game_keys_add"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      div class: "field has-addons", ->
        div class: "control", ->
          input class: "input", type: "text", name: "item", placeholder: "Game / Bundle / etc", value: @params.item
        div class: "control", ->
          input class: "input", type: "text", name: "key", placeholder: "Key / URL", value: @params.key
        div class: "control", ->
          div class: "select", ->
            element "select", name: "type", ->
              for t in *GameKeys.types
                if @params.type and GameKeys.types[t] == @params.type
                  option value: GameKeys.types[t], selected: true, t
                elseif (not @params.type) and t == GameKeys.types.humblebundle
                  option value: GameKeys.types[t], selected: true, t
                else
                  option value: GameKeys.types[t], t
        div class: "control", ->
          input class: "input", type: "submit", value: "Submit"

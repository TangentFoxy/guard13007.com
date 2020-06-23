import Widget from require "lapis.html"

import GameKeys from require "models"
import GameKeysMenu from require "widgets"

class extends Widget
  content: =>
    widget GameKeysMenu

    element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      tr ->
        th "Game"
        th "Type"
        th "Key"
        th "Status"
        th "Submit"
        th "Recipient"
        th "Delete?"
      for key in *@keys
        tr ->
          form {
            action: @url_for "game_keys_edit"
            method: "POST"
            enctype: "multipart/form-data"
          }, ->
            td ->
              div class: "control", ->
                input class: "input", type: "text", name: "item", value: key.item
            td ->
              div class: "control", ->
                div class: "select", ->
                  element "select", name: "type", ->
                    for t in *GameKeys.types
                      if t == GameKeys.types[key.type]
                        option value: GameKeys.types[t], selected: true, t
                      else
                        option value: GameKeys.types[t], t
            td ->
              div class: "control", ->
                input class: "input", type: "text", name: "key", value: key.key
            td ->
              div class: "control", ->
                div class: "select", ->
                  element "select", name: "status", ->
                    for s in *GameKeys.statuses
                      if s == GameKeys.statuses[key.status]
                        option value: GameKeys.statuses[s], selected: true, s
                      else
                        option value: GameKeys.statuses[s], s
            td ->
              input type: "hidden", name: "id", value: key.id
              div class: "control", ->
                input class: "button", type: "submit", value: "Update"
            td ->
              div class: "control", ->
                input class: "input", type: "text", name: "recipient", value: key.recipient
            td ->
              div class: "control", ->
                input type: "checkbox", name: "delete"

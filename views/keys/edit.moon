import Widget from require "lapis.html"

import Keys from require "models"
import KeysMenu from require "widgets"

class extends Widget
  content: =>
    widget KeysMenu

    element "table", ->
      tr ->
        th "Item"
        th "Type"
        th "Key"
        th "Status"
        th "Submit"
        th "Recipient"
        th "Delete?"
      for key in *@keys
        tr ->
          form {
            action: @url_for "keys_edit"
            method: "POST"
            enctype: "multipart/form-data"
          }, ->
            td ->
              div ->
                input type: "text", name: "item", value: key.item
            td ->
              div ->
                div ->
                  element "select", name: "type", ->
                    for t in *Keys.types
                      if t == Keys.types[key.type]
                        option value: Keys.types[t], selected: true, t
                      else
                        option value: Keys.types[t], t
            td ->
              div ->
                input type: "text", name: "key", value: key.key
            td ->
              div ->
                div ->
                  element "select", name: "status", ->
                    for s in *Keys.statuses
                      if s == Keys.statuses[key.status]
                        option value: Keys.statuses[s], selected: true, s
                      else
                        option value: Keys.statuses[s], s
            td ->
              input type: "hidden", name: "id", value: key.id
              div ->
                input class: "button", type: "submit", value: "Update"
            td ->
              div ->
                input type: "text", name: "recipient", value: key.recipient
            td ->
              div ->
                input type: "checkbox", name: "delete"

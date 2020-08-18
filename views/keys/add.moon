import Widget from require "lapis.html"

import Keys from require "models"
import KeysMenu from require "widgets"

class extends Widget
  content: =>
    widget KeysMenu

    form {
      action: @url_for "keys_add"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      input type: "text", name: "item", placeholder: "Item", value: @params.item
      input type: "text", name: "key", placeholder: "Key, URL, or instructions for redemption", value: @params.key
      element "select", name: "type", ->
        for t in *Keys.types
          if @params.type and Keys.types[t] == @params.type
            option value: Keys.types[t], selected: true, t
          elseif (not @params.type) and t == Keys.types.humblebundle
            option value: Keys.types[t], selected: true, t
          else
            option value: Keys.types[t], t
      input type: "submit", value: "Submit"

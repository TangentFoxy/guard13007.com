import Widget from require "lapis.html"

import Keys from require "models"
import KeysMenu from require "widgets"

class extends Widget
  content: =>
    widget KeysMenu

    p "Keys on this list will either be given out to someone in an upcomming video, or given out to someone requesting them from me. Contact me on Discord if you want a key on this list."
    element "table" ->
      tr ->
        th "Item"
        th "Type"
      for key in *@keys
        tr ->
          td key.item
          td Keys.types\to_name(key.type)

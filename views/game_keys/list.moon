import Widget from require "lapis.html"

import GameKeys from require "models"
import autoload from require "locator"
import GameKeysMenu from autoload "widgets"

class extends Widget
  content: =>
    widget GameKeysMenu

    p "Keys on this list will either be given out to someone in an upcomming video, or given out to someone requesting them from me. Contact me on Discord if you want a key on this list."
    element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      tr ->
        th "Game"
        th "Type"
      for key in *@keys
        tr ->
          td key.game
          td GameKeys.types[key.type]

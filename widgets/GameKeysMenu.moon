import Widget from require "lapis.html"

class GameKeysMenu extends Widget
  content: =>
    div class: "field is-grouped", ->
      p class: "control", ->
        if @route_name == "game_keys_add"
          a class: "button", href: @url_for("game_keys_add"), disabled: true, "Add Keys"
        else
          a class: "button", href: @url_for("game_keys_add"), "Add Keys"
      p class: "control", ->
        if @route_name == "game_keys_list"
          a class: "button", href: @url_for("game_keys_list"), disabled: true, "List Keys"
        else
          a class: "button", href: @url_for("game_keys_list"), "List Keys"
      if @user and @user.admin
        p class: "control", ->
          if @route_name == "game_keys_edit"
            a class: "button", href: @url_for("game_keys_edit"), disabled: true, "Edit Keys"
          else
            a class: "button", href: @url_for("game_keys_edit"), "Edit Keys"

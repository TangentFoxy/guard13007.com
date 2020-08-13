import Widget from require "lapis.html"

class KeysMenu extends Widget
  content: =>
    div ->
      p ->
        if @route_name == "keys_add"
          a href: @url_for("keys_add"), disabled: true, "Add Keys"
        else
          a href: @url_for("keys_add"), "Add Keys"
      p ->
        if @route_name == "keys_list"
          a href: @url_for("keys_list"), disabled: true, "List Keys"
        else
          a href: @url_for("keys_list"), "List Keys"
      if @user and @user.admin
        p ->
          if @route_name == "keys_edit"
            a href: @url_for("keys_edit"), disabled: true, "Edit Keys"
          else
            a href: @url_for("keys_edit"), "Edit Keys"

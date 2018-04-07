import Widget from require "lapis.html"

class MotorcycleMenu extends Widget
  content: =>
    div class: "field is-grouped", ->
      p class: "control", ->
        if @route_name == "motorcycle_add"
          a class: "button", href: @url_for("motorcycle_add"), disabled: true, "Add Entry"
        else
          a class: "button", href: @url_for("motorcycle_add"), "Add Entry"
      p class: "control", ->
        if @route_name == "motorcycle_list"
          a class: "button", href: @url_for("motorcycle_list"), disabled: true, "History"
        else
          a class: "button", href: @url_for("motorcycle_list"), "History"
      if @user and @user.admin
        p class: "control", ->
          if @route_name == "motorcycle_edit"
            a class: "button", href: @url_for("motorcycle_edit"), disabled: true, "Edit Entries"
          else
            a class: "button", href: @url_for("motorcycle_edit"), "Edit Entries"

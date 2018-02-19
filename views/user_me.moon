import Widget from require "lapis.html"

class extends Widget
  content: =>
    p "Username: #{@user.name} (#{@user.id})"
    p "Email Address: #{@user.email}"
    p "Is admin? #{@user.admin}"
    p -> a href: @url_for("user_edit"), "Edit"

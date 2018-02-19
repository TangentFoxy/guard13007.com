import Widget from require "lapis.html"

class extends Widget
  content: =>
    p "#{#@users} users."
    -- TODO rewrite as table
    ul ->
      for user in *@users
        if user.admin
          li "(admin) #{user.name} (#{user.id}) #{user.email}"
        else
          li "#{user.name} (#{user.id}) #{user.email}"

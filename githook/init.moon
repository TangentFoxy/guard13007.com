path = (...)\gsub "%.", "/"

if "init" == (...)\sub -4
  path = (...)\sub 1, -5
  unless path
    path = "."

return require "#{path}/githook"

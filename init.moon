path = (...)\gsub("%.", "/")\sub 1, -2

if "init" == (...)\sub -4
  path = path\sub 1, -5
  unless path
    path = "."

return require "#{path}/githook"

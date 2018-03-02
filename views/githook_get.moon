import Widget from require "lapis.html"

class extends Widget
  content: =>
    h2 "#{@results.json.status\sub(1, 1)\upper!}#{@results.json.status\sub 2}"
    element "table", ->
      tr ->
        for code in *@results.json.exit_codes
          th code
    pre @results.json.log

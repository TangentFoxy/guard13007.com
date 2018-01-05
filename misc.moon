lapis = require "lapis"

class extends lapis.Application
  [games: "/games"]: =>
    @title = "Guard's Games"
    @html ->
      -- link rel: "stylesheet", href:  "/static/css/itchEmbed.css"
      div class: "columns", ->
        div class: "column", ->
          div class: "itchEmbed", -> -- Realms
            iframe src: "https://itch.io/embed/163537?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- 300 Words to Save Your Ship
            iframe src: "https://itch.io/embed/46307?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- FADE
            iframe src: "https://itch.io/embed/65758?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- Opcode-Powered Shuttle
            iframe src: "https://itch.io/embed/47156?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "column", ->
          div class: "itchEmbed", -> -- SCP Clicker
            iframe src: "https://itch.io/embed/133080?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- RGB - The Color Chooser
            iframe src: "https://itch.io/embed/50932?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- Grand Theft Papercut
            iframe src: "https://itch.io/embed/46316?linkback=true", width: 552, height: 167, frameborder: 0
          div class: "itchEmbed", -> -- Psychology
            iframe src: "https://itch.io/embed/46311?linkback=true", width: 552, height: 167, frameborder: 0

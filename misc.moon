lapis = require "lapis"

class extends lapis.Application
  [games: "/games"]: =>
    @title = "My Games"
    @html ->
      div class: "tile is-ancestor", ->
        div class: "tile is-4", -> -- Realms
          iframe src: "https://itch.io/embed/163537?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-4", -> -- 300 Words to Save Your Ship
          iframe src: "https://itch.io/embed/46307?linkback=true", width: 552, height: 167, frameborder: 0

        div class: "tile is-4", -> -- SCP Clicker
          iframe src: "https://itch.io/embed/133080?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-4", -> -- Psychology
          iframe src: "https://itch.io/embed/46311?linkback=true", width: 552, height: 167, frameborder: 0

        div class: "tile is-4", -> -- RGB - The Color Chooser
          iframe src: "https://itch.io/embed/50932?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-4", -> -- Opcode-Powered Shuttle
          iframe src: "https://itch.io/embed/47156?linkback=true", width: 552, height: 167, frameborder: 0

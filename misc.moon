lapis = require "lapis"

class extends lapis.Application
  [games: "/games"]: =>
    @title = "My Games"
    @html ->
      div class: "tile is-ancestor is-parent", ->
        div class: "tile is-child is-6", -> -- Realms
          iframe src: "https://itch.io/embed/163537?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-child is-6", -> -- 300 Words to Save Your Ship
          iframe src: "https://itch.io/embed/46307?linkback=true", width: 552, height: 167, frameborder: 0

        div class: "tile is-child is-6", -> -- SCP Clicker
          iframe src: "https://itch.io/embed/133080?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-child is-6", -> -- Psychology
          iframe src: "https://itch.io/embed/46311?linkback=true", width: 552, height: 167, frameborder: 0

        div class: "tile is-child is-6", -> -- RGB - The Color Chooser
          iframe src: "https://itch.io/embed/50932?linkback=true", width: 552, height: 167, frameborder: 0
        div class: "tile is-child is-6", -> -- Opcode-Powered Shuttle
          iframe src: "https://itch.io/embed/47156?linkback=true", width: 552, height: 167, frameborder: 0

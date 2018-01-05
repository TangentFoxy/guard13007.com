lapis = require "lapis"

class extends lapis.Application
  [games: "/games"]: =>
    @title = "My Games"
    @html ->
      iframe src: "https://itch.io/embed/163537?linkback=true", width: 552, height: 167, frameborder: 0 -- Realms
      iframe src: "https://itch.io/embed/46307?linkback=true", width: 552, height: 167, frameborder: 0 -- 300 Words to Save Your Ship
      iframe src: "https://itch.io/embed/50932?linkback=true", width: 552, height: 167, frameborder: 0 -- RGB - The Color Chooser

      iframe src: "https://itch.io/embed/133080?linkback=true", width: 552, height: 167, frameborder: 0 -- SCP Clicker
      iframe src: "https://itch.io/embed/46311?linkback=true", width: 552, height: 167, frameborder: 0 -- Psychology
      iframe src: "https://itch.io/embed/47156?linkback=true", width: 552, height: 167, frameborder: 0 -- Opcode-Powered Shuttle

lapis = require "lapis"

class RedirectsApp extends lapis.Application
  @path: "/redirects"

  "/discord": =>
    redirect_to: "https://discord.gg/UBehCVN"
  "/github": => -- never used
    redirect_to: "https://github.com/TangentFoxy"
  "/itch.io": =>
    redirect_to: "https://tangentfox.itch.io/"
  "/patreon": => -- deprecated, using direct links now
    redirect_to: "https://patreon.com/guard13007"
  "/player.me": =>
    redirect_to: "https://player.me/guard13007"
  "/steam": => -- never used
    redirect_to: "https://steamcommunity.com/id/tangentfox"
  "/twitch.tv": =>
    redirect_to: "https://twitch.tv/tangentfox"
  "/twitter": =>
    redirect_to: "https://twitter.com/TangentFoxy"

  "/hoodie-ninja.html": =>
    redirect_to: "https://stampyd.itch.io/hoodie-ninja"
  "/jump-city-game.html": =>
    redirect_to: "https://mrkittyamazzing.itch.io/jump-city"
  "/oh-beehive-game.html": =>
    redirect_to: "https://pokesie.itch.io/oh-beehive"
  "/pyramid-game.html": =>
    redirect_to: "https://pixelspill.itch.io/pyramid"
  "/st-peters-judge-o-rama.html": =>
    redirect_to: "https://oxyoxspring.itch.io/judge-o-rama"

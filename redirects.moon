lapis = require "lapis"

class extends lapis.Application
    @path: "/redirects"

    "/discord": =>
        redirect_to: "https://discord.gg/DjB84MP", status: 302

    "/github": => -- not in use
        redirect_to: "https://github.com/guard13007", status: 302

    "/itch.io": =>
        redirect_to: "https://guard13007.itch.io/", status: 302

    "/patreon": => -- deprecated, using direct links now
        redirect_to: "https://patreon.com/guard13007", status: 302

    "/player.me": =>
        redirect_to: "https://player.me/guard13007", status: 302

    "/steam": => -- not in use
        redirect_to: "https://steamcommunity.com/id/guard13007", status: 302

    "/twitch.tv": =>
        redirect_to: "https://twitch.tv/guard13007", status: 302

    "/twitter": =>
        redirect_to: "https://twitter.com/guard13007", status: 302

    "/hoodie-ninja.html": =>
        redirect_to: "https://stampyd.itch.io/hoodie-ninja", status: 302

    "/jump-city-game.html": =>
        redirect_to: "https://mrkittyamazzing.itch.io/jump-city", status: 302

    "/oh-beehive-game.html": =>
        redirect_to: "https://pokesie.itch.io/oh-beehive", status: 302

    "/pyramid-game.html": =>
        redirect_to: "https://pixelspill.itch.io/pyramid", status: 302

    "/st-peters-judge-o-rama.html": =>
        redirect_to: "https://oxyoxspring.itch.io/judge-o-rama", status: 302

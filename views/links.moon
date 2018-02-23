import Widget from require "lapis.html"

class extends Widget
  content: =>
    style "*{margin:0;padding:0;}"
    img src: "/static/img/links/LogoSquare_YTresize.png", hidden: true
    a href: "/redirects/discord", -> img src: "/static/img/links/Discord.png"
    a href: "/redirects/twitter", -> img src: "/static/img/links/Twitter.png"
    a href: "/redirects/twitch.tv", -> img src: "/static/img/links/Twitch.tv.png"
    a href: "/redirects/itch.io", -> img src: "/static/img/links/Itch.io.png"
    -- a href: "/redirects/patreon", -> img src: "/static/img/links/Patreon.png"

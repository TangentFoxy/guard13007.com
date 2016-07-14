lapis = require "lapis"

class extends lapis.Application
    "/chat": =>
        @title = Chat on Discord
        @html ->
            h2 "My Discord Server"
            div ->
                iframe src: "https://discordapp.com/widget?id=98612945000345600&amp;theme=dark",
                    width: 350, height: 500, allowtransparency: true, frameborder: 0
            h2 "YouTuber Gamers"
            p ->
                text "Kind of ghost town right now, but "
                em "you"
                text " can fix that."
            div ->
                iframe src: "https://discordapp.com/widget?id=98996659454775296&amp;theme=dark",
                    width: 350, height: 500, allowtransparency: true, frameborder: 0
            h2 "Kerbal Warfare"
            p "(Will be) Used for organizing multiplayer Kerbal warfare."
            div ->
                iframe src: "https://discordapp.com/widget?id=115597534726062086&amp;theme=dark",
                    width: 350, height: 500, allowtransparency: true, frameborder: 0

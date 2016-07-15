lapis = require "lapis"

class extends lapis.Application
    "/chat": =>
        @title = "Chat on Discord"
        @html ->
            h2 "My Discord Server"
            div ->
                iframe src: "https://discordapp.com/widget?id=98612945000345600&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0
            h2 "YouTuber Gamers"
            p ->
                text "Kind of ghost town right now, but "
                em "you"
                text " can fix that."
            div ->
                iframe src: "https://discordapp.com/widget?id=98996659454775296&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0
            h2 "Kerbal Warfare"
            p "(Will be) Used for organizing multiplayer Kerbal warfare."
            div ->
                iframe src: "https://discordapp.com/widget?id=115597534726062086&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0

    "/contact": =>
        @title = "Contact Info"
        @html ->
            link rel: "stylesheet", href: @build_url "static/css/pure-min.css"
            link rel: "stylesheet", href: @build_url "static/css/contact.css"
            div id: "container", ->
                h1 "Contact Info"
                ul ->
                    li ->
                        text "Email: "
                        a href: "mailto:paul.liverman.iii@gmail.com", "paul.liverman.iii@gmail.com"
                    li ->
                        text "Discord (my server): "
                        a href: "https://discord.gg/0Y9OTJpXWhFJBEMX", target: "_blank", "invite link"
                    li ->
                        text "Twitter: "
                        a href: "https://twitter.com/guard13007", target: "_blank", "@Guard13007"
                    li ->
                        text "Player.me: "
                        a href: "https://player.me/guard13007", target: "_blank", "Guard13007"
                p ->
                    text "Do "
                    em "not"
                    text " send messages to my YouTube inbox."

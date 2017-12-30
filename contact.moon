lapis = require "lapis"

class extends lapis.Application
    [chat: "/chat"]: =>
        @title = "Chat on Discord"
        @html ->
            link rel: "stylesheet", href:  "/static/css/pure-responsive-grids.css"
            div class: "pure-u-1-2", ->
                h2 style: "text-align: left;", "My Discord Server"
                iframe src: "https://discordapp.com/widget?id=98612945000345600&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0
                p ->
                    text "Please read the "
                    a href: @url_for("chat_rules"), "rules"
                    text " and try not to break them. ;)"
            div class: "pure-u-1-2", ->
                h2 style: "text-align: left;", "YouTuber Gamers"
                iframe src: "https://discordapp.com/widget?id=98996659454775296&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0
                p ->
                    text "Kind of a ghost town right now, but "
                    em "you"
                    text " can fix that."
            --div class: "pure-u-1-2", ->
            --    h2 style: "text-align: left;", "Kerbal Warfare"
            --    iframe src: "https://discordapp.com/widget?id=115597534726062086&amp;theme=dark", width: 350, height: 500, allowtransparency: true, frameborder: 0
            --    p "Used for organizing multiplayer Kerbal warfare."

    [chat_rules: "/chat/rules"]: =>
        @title = "Guard's Discord - Rules"
        @html ->
            ol ->
                li "Do not post links to pirated software. You can discuss piracy, but do not link to illegal downloads."
                li "No constant advertising. It's fine to tell people you have a YouTube channel or are working on something, but do not mention it constantly."
                li "By default, no one can post links except in the #picsandlinks and #shitpost channels. If you build up trust, you will be allowed to post in other channels."
                li "No copypasta."
                li ->
                    text "The channels:"
                    ul ->
                        li "#general is for general conversation and where we most often chat."
                        li "#computers-n-code is for programming, hacking, code, other technological items or discussions."
                        li "#trusted is a private channel for people I trust."
                        li "#music is for sharing music! :D"
                        li "#art is for sharing art."
                        li "#bot-abuse is for playing with BoomBot, developed by Lomeli. :P"
                        li "#picsandlinks is for sharing stuff, as long as it's not crap."
                        li "#shitpost is for random crap..since some people want that for some reason. >.>"
                li "Racism is bad. Let's just not have it."
                li "Please refrain from using offensive language meant to provoke an argument with no constructive purpose."
                hr!
                li "More rules may be added as needed, obviously."
                li title: "If you don't like it, see http://xkcd.com/1357/", "And finally, if you are causing significant annoyance to several members, especially if they are friends of mine, I may ban you."

    [profiles: "/contact/profiles"]: =>
        @title = "Guard13007's Profiles"
        @html ->
            ul ->
                li ->
                    a href: "https://sketchfab.com/Guard13007", target: "_blank", "Sketchfab"
                    text " (for sharing 3D models, I mostly use it for StarMade designs)"
                li ->
                    a href: "http://www.last.fm/user/Guard13007", target: "_blank", "Last.fm"
                    text " (for sharing music I think? I don't use it anymore)"

    [contact: "/contact"]: =>
        @title = "Contact Info"
        @html ->
            ul ->
                li ->
                    text "Email (business): "
                    a href: "mailto:paul.liverman.iii@gmail.com", "paul.liverman.iii@gmail.com"
                    text " (use "
                    a href: @url_for("ksp_submit_crafts"), "this form"
                    text " for KSP craft submissions!)"
                li ->
                    text "Discord (general contact/hanging out): "
                    a href: "https://discord.gg/DjB84MP", target: "_blank", "invite link"
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

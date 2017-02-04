html = require "lapis.html"

class extends html.Widget
    content: =>
        html_5 ->
            head ->
                title @title or "Guard13007.com"
                script -> raw "
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

                    ga('create', 'UA-82645104-1', 'auto'); ga('send', 'pageview');"
                link rel: "stylesheet", href: @build_url "static/css/pure-min.css"
                link rel: "stylesheet", href: @build_url "static/css/site.css"
            body ->
                noscript "This website requies JavaScript for many of its pages."
                a name: "top"
                div style: "position: fixed; top: 0; width: 100%;", ->
                    div id: "header", ->
                        div class: "pure-menu pure-menu-horizontal", ->
                            ul class: "pure-menu-list", ->
                                li class: "pure-menu-item pure-menu-selected", ->
                                    a href: @url_for("index"), class: "pure-menu-link", "Home"
                                li class: "pure-menu-item", ->
                                    a href: @url_for("faq"), class: "pure-menu-link", "FAQ"
                                li class: "pure-menu-item pure-menu-has-children pure-menu-allow-hover", ->
                                    a href: "#", class: "pure-menu-link", "Contact"
                                    ul class: "pure-menu-children", ->
                                        li class: "pure-menu-item", -> a href: @url_for("contact"), class: "pure-menu-link", style: "min-width:78px;", "Info"
                                        li class: "pure-menu-item", -> a href: @url_for("profiles"), class: "pure-menu-link", style: "min-width:78px;", "Profiles"
                                        li class: "pure-menu-item", -> a href: @url_for("chat"), class: "pure-menu-link", style: "min-width:78px;", "Chat"
                                li class: "pure-menu-item pure-menu-has-children pure-menu-allow-hover", ->
                                    a href: "#", class: "pure-menu-link", "Kerbal Space Program"
                                    ul class: "pure-menu-children", ->
                                        li class: "pure-menu-item", -> a href: @url_for("ksp_submit_crafts"), class: "pure-menu-link", style: "min-width:190px", "Submit a craft!"
                                        li class: "pure-menu-item", -> a href: @url_for("ksp_craft_list"), class: "pure-menu-link", style: "min-width:190px", "Craft sent in"
                                li class: "pure-menu-item", ->
                                    a href: @url_for("games"), class: "pure-menu-link", "Games"
                                li class: "pure-menu-item", ->
                                    a href: @url_for("blog_index"), class: "pure-menu-link", "Blog"
                                li class: "pure-menu-item", ->
                                    a href: @url_for("john_submissions"), class: "pure-menu-link", "John"
                div id: "container", ->
                    if @title
                        h1 @title
                    if @info
                        div class: "info", ->
                            button class: "pure-button", onclick: "var e = document.getElementsByClassName('info')[0]; e.parentNode.removeChild(e);", "X"
                            text @info
                    @content_for "inner"
                div style: "position: fixed; bottom: 0; width: 100%;", ->
                    div id: "footer", ->
                        if @session.id
                            a href: @url_for("user_me"), class: "pure-button", "You"
                            text " | "
                            a href: @url_for("user_logout"), class: "pure-button", "Log Out"
                        else
                            a href: @url_for("user_login"), class: "pure-button", "Log In"
                            text " | "
                            a href: @url_for("user_new"), class: "pure-button", "New User"
                        text " | This website is open-source... "
                        a href: "https://github.com/Guard13007/guard13007.com", "Help me with it?"

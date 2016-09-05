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
                a name: "top"
                div id: "container", ->
                    if @title
                        h1 @title
                        if @session.info
                            div class: "info", ->
                                button class: "pure-button", onclick: "var e = document.getElementsByClassName('info')[0]; e.parentNode.removeChild(e);", "X"
                                text @session.info
                                @session.info = nil
                    @content_for "inner"
                div style: "position: fixed; bottom: 0; width: 100%", ->
                    div id: "footer", ->
                        if @session.id
                            a href: @url_for("user_me"), "You"
                            text " | "
                            a href: @url_for("user_logout"), "Log Out"
                        else
                            a href: @url_for("user_login"), "Log In"
                            text " | "
                            a href: @url_for("user_new"), "New User"
                        text " | This website is open-source... "
                        a href: "https://github.com/Guard13007/guard13007.com", "Help me with it?"

import Widget from require "lapis.html"
config = require("lapis.config").get!

class extends Widget
  content: =>
    html_5 class: "has-navbar-fixed-top has-navbar-fixed-bottom", ->
      head ->
        if @title
          title "#{@title} - Guard13007.com"
        else
          title "Guard13007.com"
        meta name: "viewport", content: "width=device-width, initial-scale=1"
        if key = settings["guard13007.google-analytics-key"]
          script -> raw "
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
            ga('create', '#{key}', 'auto'); ga('send', 'pageview');
          "

        link rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.6.1/css/bulma.min.css", integrity: "sha256-v5YlJGWVLS5hQ+o48fBzCKHEP2vMNsku57x3CosYykc=", crossorigin: "anonymous"
        script src: "/static/js/burgers.js"
        link rel: "stylesheet", href: "/static/css/site.css"
      body ->
        -- noscript "This website requies JavaScript for many of its pages."
        -- TODO make a better warning for JavaScript (perhaps in the footer)
        -- TODO make as little as possible required JavaScript (I think only craft submission pages truly need it)
        color = "dark"
        if config._name == "development"
          color = "danger"
        nav class: "navbar is-fixed-top is-#{color}", ->
          div class: "navbar-brand", ->
            a class: "navbar-item", href: @url_for("index"), ->
              img src: "/static/img/logo.png"
            div class: "navbar-burger burger", "data-target": "navbar", ->
              span!
              span!
              span!
          div id: "navbar", class: "navbar-menu", ->
            div class: "navbar-start", ->
              a class: "navbar-item", href: "/faq", "FAQ"
              a class: "navbar-item", href: "/games", "My Games"
              -- div class: "navbar-item has-dropdown is-hoverable", ->
              --   p class: "navbar-link is-unselectable", "My Games"
              --   div class: "navbar-dropdown", ->
              --     div class: "navbar-item menu", ->
              --       ul class: "menu-list", ->
              --         li -> a href: "/games", "All Games"
              --         li -> a href: "/games/support", "Support"
              div class: "navbar-item has-dropdown is-hoverable", ->
                p class: "navbar-link is-unselectable", "Videos"
                div class: "navbar-dropdown", ->
                  div class: "navbar-item menu", ->
                    ul class: "menu-list", ->
                      li -> a href: "/videos", "All Videos"
                      -- li -> a href: "/playlists", "Playlists"
                      li ->
                        a href: "/gaming", disabled: true, "Gaming"
                        ul ->
                          -- li -> a href: "/gaming/ksp", "Kerbal Space Program"
                          li ->
                            a href: "/gaming/ksp", disabled: true, "Kerbal Space Program"
                            div class: "navbar-item menu", ->
                              ul class: "menu-list", ->
                                li -> a href: "/gaming/ksp/crafts", "View submitted craft"
                                li -> a href: "/gaming/ksp/submit", "Submit a craft"
                          -- li -> a href: "/gaming/starmade", "StarMade"
              a class: "navbar-item", href: "/posts", "Blog"
              -- div class: "navbar-item has-dropdown is-hoverable", ->
              --   p class: "navbar-link is-unselectable", "Blog"
              --   div class: "navbar-dropdown", ->
              --     div class: "navbar-item menu", ->
              --       ul class: "menu-list", ->
              --         li -> a href: "/posts", "All Posts"
              --         li -> a href: "/blog/art", "Art"
              --         li -> a href: "/blog/reviews", "Reviews"
              --TODO Code
              -- div class: "navbar-item has-dropdown is-hoverable", ->
              --   p class: "navbar-link is-unselectable", "Code"
              --   div class: "navbar-dropdown", ->
              --     div class: "navbar-item menu", ->
              --       ul class: "menu-list", ->
              --         li -> a href: "/code", "All Code"
              --         li ->
              --           a href: "/code/software", "Software"
              --           ul ->
              --             li -> a href: "/code/software/support", "Support"
              --         li -> a href: "/code/libraries", "Libraries"
              --         li -> a href: "/code/tutorials", "Tutorials"
              --         li -> a href: "/code/portfolio", "Portfolio"
              --         li -> a href: "/code/resume", "Resume"
              div class: "navbar-item has-dropdown is-hoverable", ->
                p class: "navbar-link is-unselectable", "Contact"
                div class: "navbar-dropdown", ->
                  div class: "navbar-item menu", ->
                    ul class: "menu-list", ->
                      li -> a href: "/contact", "Contact Info"
                      li -> a href: "/contact/profiles", "Me Elsewhere"
                      -- li -> a href: "/patronage", "Support Me"
            -- div class: "navbar-end"
        -- a name: "top"
        section class: "section", ->
          if @info
            div class: "notification is-primary", ->
              button class: "delete", onclick: "var e = document.getElementsByClassName('notification')[0]; e.parentNode.removeChild(e);"
              text @info
          div class: "container has-text-centered", ->
            if @title
              h1 class: "title", @title
            if @subtitle
              h2 class: "subtitle", @subtitle
          div class: "container", ->
            @content_for "inner"
        nav class: "navbar is-fixed-bottom is-light", ->
          div class: "navbar-brand", ->
            if @user and @user.admin
              div class: "navbar-item has-dropdown has-dropdown-up is-hoverable", ->
                p class: "navbar-link is-unselectable", "Admin"
                div class: "navbar-dropdown", ->
                  div class: "navbar-item menu", ->
                    ul class: "menu-list", ->
                      li -> a href: @url_for("user_list"), "List Users"
                      li -> a href: @url_for("user_admin"), "User Administration"
                      li -> a href: @url_for("posts_admin_index"), "All Posts"
                      li -> a href: @url_for("posts_new"), "New Post"
            div class: "navbar-item", ->
              div class: "level", ->
                div class: "level-left", ->
                  div class: "level-item", ->
                    div class: "field is-grouped", ->
                      if @user
                        div class: "control", ->
                          a class: "button", href: @url_for("user_me"), "You"
                        div class: "control", ->
                          a class: "button", href: @url_for("user_logout", nil, redirect: @url_for(@route_name, @params)), "Log Out"
                      else
                        div class: "control", ->
                          a class: "button", href: @url_for("user_login"), "Log In"
                        div class: "control", ->
                          a class: "button", href: @url_for("user_new"), "New User"
                  div class: "level-item", ->
                    text "This website is open source on"
                    raw "&nbsp;"
                    -- TODO modify to use icon ?
                    a href: "https://github.com/Guard13007/guard13007.com", "GitHub"
                    text "."

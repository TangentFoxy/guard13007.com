import Widget from require "lapis.html"
config = require("lapis.config").get!

import settings from require "utility"

class extends Widget
  content: =>
    html_5 ->
      head ->
        if @title
          title "#{@title}, #{settings['site.title']}"
        else
          title settings['site.title']

        meta name: "viewport", content: "width=device-width, initial-scale=1"
        link rel: "stylesheet", href: "/static/css/site.css"

        if key = settings["site.google-analytics-key"]
          script -> raw "
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
            ga('create', '#{key}', 'auto'); ga('send', 'pageview');
          "

      body ->
        ul ->
          a href: "/faq", "FAQ"
          -- a href: "/posts", "Blog" -- TODO remove "blog" but keep posts
          a href: "https://blog.tangentfox.com/", "Blog"
          -- TODO Support link (Pateon, Paypal, etc)
          -- a href: "/games", "My Games"
          -- a href: "/videos", "All Videos"
          -- a href: "/gaming/ksp", disabled: true, "Kerbal Space Program"
          a href: "/gaming/ksp/crafts", "KSP Submissions"
          -- a href: "/gaming/ksp/submit", "Submit a craft"
          -- TODO Giveaways (/keys) link
          -- a href: "/contact", "Contact Info"
          -- a href: "/contact/profiles", "Me Elsewhere"
        if @info
          text @info
        if @title
          h1 @title
        if @subtitle
          h2 @subtitle
        div class: "container", ->
          @content_for "inner"
        ul ->
          if @user
            if @user.admin
              a href: @url_for("console"), "Console"
              a href: @url_for("user_admin"), "User Administration"
              a href: @url_for("user_list"), "List Users"
              a href: @url_for("posts_admin_index"), "All Posts"
              a href: @url_for("posts_new"), "New Post"
            a href: @url_for("user_me"), "You"
            a href: @url_for("user_logout", nil, redirect: @url_for(@route_name, @params)), "Log Out"
          else
            a href: @url_for("user_login", nil, redirect: @url_for(@route_name, @params)), "Log In"
            a href: @url_for("user_new", nil, redirect: @url_for(@route_name, @params)), "New User"

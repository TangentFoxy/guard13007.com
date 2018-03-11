import Widget from require "lapis.html"
config = require("lapis.config").get!

class extends Widget
  content: =>
    html_5 ->
      head ->
        if @title
          title "#{@title} - Guard13007.com"
        else
          title "Guard13007.com"
        if key = settings["guard13007.google-analytics-key"]
          script -> raw "
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
            ga('create', '#{key}', 'auto'); ga('send', 'pageview');
          "

      body ->
        @content_for "inner"

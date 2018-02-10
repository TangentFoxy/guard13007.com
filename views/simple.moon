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
      body ->
        @content_for "inner"

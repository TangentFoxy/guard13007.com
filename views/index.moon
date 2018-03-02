import Widget from require "lapis.html"

class extends Widget
  content: =>
    div class: "content", ->
      h1 "Welcome"
      p ->
        text "For the latest information and whatnot, "
        a href: @url_for("posts_index"), "go to the blog"
        text "!"
      p "This site has been slowly being upgraded in every way except this page for quite a long time. I should do something about that."
      p ->
        text "Want to submit a craft? "
        a href: @url_for("ksp_crafts_submit"), "Click here!"
        text " Want to see the submitted crafts? "
        a href: @url_for("ksp_crafts_index"), "Click here!"

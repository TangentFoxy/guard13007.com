import Widget from require "lapis.html"

class extends Widget
    content: =>
        h1 "Welcome"
        iframe width: 560, height: 315, src: "https://www.youtube.com/embed/_fy8rKNoYx0", frameborder: 0, allowfullscreen: true
        p ->
            text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
            a href: @build_url("map.html"), "here's a link"
            text " to my old site map."
        p ->
            text "Want to submit a craft? "
            a href: @url_for("ksp_submit_crafts"), "Click here!"
            text " Want to see the submitted crafts? "
            a href: @url_for("ksp_craft_list"), "Click here!"
        p ->
            text "I also just started a blog on here for random rambly bits. You can see it "
            a href: @url_for("blog_index"), "here"
            text "!"

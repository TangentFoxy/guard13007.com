import Widget from require "lapis.html"

class extends Widget
    content: =>
        h1 "Welcome"
        p ->
            text "My server is soon to be running on Lapis moreso than hand-coded HTML. In the meantime, "
            a href: ("map.html"), "here's a link"
            text " to my old site map."
        p ->
            text "Want to submit a craft? "
            a href: @url_for("ksp_crafts_submit"), "Click here!"
            text " Want to see the submitted crafts? "
            a href: @url_for("ksp_crafts_index"), "Click here!"
        p ->
            text "I also just started a blog on here for random rambly bits. You can see it "
            a href: @url_for("posts_index"), "here"
            text "!"
        -- p "Test successful."

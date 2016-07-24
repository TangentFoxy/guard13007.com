lapis = require "lapis"

class extends lapis.Application
    @path: "/blog"
    @name: "blog_"

    [index: "/"]: =>
        @title = "Guard's Microblog"
        @html ->
            -- the difference in meaning between wat and what
            -- what I know about security of sites...

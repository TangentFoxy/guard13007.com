lapis = require "lapis"
--discount = require "discount"

import respond_to from require "lapis.application"
import slugify, time_ago_in_words from require "lapis.util"

Posts = require "models.Posts"
Users = require "users.models.Users"

class extends lapis.Application
    @path: "/blog"
    @name: "blog_"

    [index: "(/:page[%d])"]: =>
        page = tonumber(@params.page) or 1
        @title = "Guard's Microblog"

        Paginator = Posts\paginated "WHERE status = ? ORDER BY pubdate DESC", Posts.statuses.published, per_page: 6
        posts = Paginator\get_page page
        if #posts < 1 and Paginator\num_pages! > 0
            return redirect_to: @url_for("blog_index", page: Paginator\num_pages!)

        @html ->
            link rel: "stylesheet", href: @build_url "static/css/blog.css"
            script src: @build_url "static/js/marked.min.js"
            if page > 1
                a class: "pure-button", href: @url_for("blog_index", page: 1), "Most Recent"
                a class: "pure-button", href: @url_for("blog_index", page: page - 1), "Newer"
            else
                a class: "pure-button pure-button-disabled", "Most Recent"
                a class: "pure-button pure-button-disabled", "Newer"
            span style: "float: right;", ->
                if page < Paginator\num_pages!
                    a class: "pure-button", href: @url_for("blog_index", page: page + 1), "Older"
                    a class: "pure-button", href: @url_for("blog_index", page: Paginator\num_pages!), "Oldest"
                else
                    a class: "pure-button pure-button-disabled", "Older"
                    a class: "pure-button pure-button-disabled", "Oldest"

            for post in *posts
                div class: "post-preview", ->
                    h2 post.title
                    h3 title: post.pubdate, ->
                        a href: @url_for("blog_post", slug: post.slug), time_ago_in_words post.pubdate

                    div id: "post_#{post.slug}"
                    if post.text\len! > 500
                        --raw discount post.text\sub(1, 500) .. " ..."
                        a href: @url_for("blog_post", slug: post.slug), "Read More"
                    else
                        --raw discount post.text
                        a href: @url_for("blog_post", slug: post.slug), "View Post"
                    script -> raw "document.getElementById('post_#{post.slug}').innerHTML = marked('#{post.text\gsub("'", "\\'")\gsub "\n", "\\n"}');"

                    text " ("
                    span class: "disqus-comment-count", ["data-disqus-identifier"]: @build_url @url_for "blog_post", slug: post.slug
                    text ")"

            if @session.id and (Users\find id: @session.id).admin
                p ->
                    a class: "pure-button", href: @url_for("blog_new"), "New Post"
                    a class: "pure-button", href: @url_for("blog_drafts"), "Drafts"

            script id: "dsq-count-scr", src: "https://guard13007.disqus.com/count.js", async: true

    [post: "/post/:slug"]: =>
        if post = Posts\find slug: @params.slug
            @title = post.title
            @html ->
                --TODO some sort of back button that returns to the correct page in blog_index
                h2 title: post.pubdate, time_ago_in_words post.pubdate
                --raw discount post.text
                div id: "post_text"
                script -> raw "document.getElementById('post_text').innerHTML = marked('#{post.text\gsub("'", "\\'")\gsub "\n", "\\n"}');"
                hr!
                div id: "disqus_thread"
                script -> raw "
                    var disqus_config = function () {
                        this.page.url = '#{@build_url @url_for "blog_post", slug: post.slug}';
                        this.page.identifier = '#{@build_url @url_for "blog_post", slug: post.slug}';
                    };
                    (function() {
                        var d = document, s = d.createElement('script');
                        s.src = '//guard13007.disqus.com/embed.js';
                        s.setAttribute('data-timestamp', +new Date());
                        (d.head || d.body).appendChild(s);
                    })();"

                p -> a class: "pure-button", href: @url_for("blog_index"), "Back" -- this is shit

                if @session.id and (Users\find id: @session.id).admin
                    p ->
                        a class: "pure-button", href: @url_for("blog_new"), "New Post"
                        a class: "pure-button", href: @url_for("blog_drafts"), "Drafts"
                        a class: "pure-button", href: @url_for("blog_edit", slug: post.slug), "Edit Post"

        else
            @session.info = "That post does not exist."
            return redirect_to: @url_for "blog_index"

    [new: "/new"]: respond_to {
        GET: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            @html ->
                link rel: "stylesheet", href: @build_url "static/simplemde/simplemde.min.css"
                script src: @build_url "static/simplemde/simplemde.min.js"
                script -> raw "
                    window.onload = function () { var simplemde = new SimpleMDE({
                        autosave: {
                            enabled: true,
                            uniqueId: '#{@url_for "blog_new"}'
                        },
                        indentWithTabs: false,
                        insertTexts: {
                            link: ['[', '](https://)']
                        },
                        parsingConfig: {
                            strikethrough: false
                        },
                        renderingConfig: {
                            singleLineBreaks: false,
                            // TODO add codeSyntaxHighlighting: true // this uses highlight.js which I already love :P
                        }
                    }); }
                "
                form {
                    action: @url_for "blog_new"
                    method: "POST"
                    enctype: "multipart/form-data"
                    class: "pure-form"
                }, ->
                    text "Title: "
                    input type: "text", name: "title"
                    br!
                    textarea cols: 80, rows: 13, name: "text"
                    br!
                    text "(Note: Tables are not part of standard Markdown, and will not work.)"
                    br!
                    element "select", name: "status", ->
                        for status in *Posts.statuses
                            if status == Posts.statuses.draft
                                option value: Posts.statuses[status], selected: true, status
                            else
                                option value: Posts.statuses[status], status
                    br!
                    input class: "pure-button", type: "submit"
                    a class: "pure-button", href: @url_for("blog_drafts"), "Drafts"

        POST: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            fields = {}
            if @params.title and @params.title\len! > 0
                fields.title = @params.title
                fields.slug = slugify @params.title
            if @params.text and @params.text\len! > 0
                fields.text = @params.text
            if @params.status and @params.status\len! > 0
                fields.status = Posts.statuses\for_db tonumber @params.status

            if fields.status == Posts.statuses.published
                fields.pubdate = os.date("!%Y-%m-%d %X")
            else
                fields.pubdate = "1970-01-01 00:00:00"

            if post = Posts\create fields
                return redirect_to: @url_for "blog_edit", slug: post.slug
            else
                @session.info = "Failed to create post."
                return redirect_to: @url_for "blog_new"
    }

    [edit: "/edit/:slug"]: respond_to {
        GET: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            if post = Posts\find slug: @params.slug
                @html ->
                    link rel: "stylesheet", href: @build_url "static/simplemde/simplemde.min.css"
                    script src: @build_url "static/simplemde/simplemde.min.js"
                    script -> raw "
                        window.onload = function () { var simplemde = new SimpleMDE({
                            autosave: {
                                enabled: true,
                                uniqueId: '#{@url_for "blog_edit", slug: post.id}' // we use IDs because slugs can change
                            },
                            indentWithTabs: false,
                            insertTexts: {
                                link: ['[', '](https://)']
                            },
                            parsingConfig: {
                                strikethrough: false
                            },
                            renderingConfig: {
                                singleLineBreaks: false,
                                // TODO add codeSyntaxHighlighting: true // this uses highlight.js which I already love :P
                            }
                        }); }
                    "
                    form {
                        action: @url_for "blog_edit", slug: post.slug
                        method: "POST"
                        enctype: "multipart/form-data"
                        class: "pure-form"
                    }, ->
                        text "Title: "
                        input type: "text", name: "title", value: post.title
                        br!
                        textarea cols: 80, rows: 13, name: "text", post.text
                        br!
                        text "(Note: Tables are not part of standard Markdown, and will not work.)"
                        br!
                        element "select", name: "status", ->
                            for status in *Posts.statuses
                                if status == Posts.statuses[post.status]
                                    option value: Posts.statuses[status], selected: true, status
                                else
                                    option value: Posts.statuses[status], status
                        br!
                        --input type: "hidden", name: "slug", value: post.slug -- is this really needed?
                        input class: "pure-button", type: "submit"
                        a class: "pure-button", href: @url_for("blog_drafts"), "Drafts"
                        a class: "pure-button", href: @url_for("blog_new"), "New Post"
            else
                @session.info = "That post does not exist."
                return redirect_to: @url_for "blog_drafts"

        POST: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            if post = Posts\find slug: @params.slug
                fields = {}
                if @params.title and @params.title\len! > 0
                    fields.title = @params.title
                    fields.slug = slugify @params.title
                if @params.text and @params.text\len! > 0
                    fields.text = @params.text
                if @params.status and @params.status\len! > 0
                    fields.status = Posts.statuses\for_db tonumber @params.status

                if fields.status == Posts.statuses.published and post.pubdate == "1970-01-01 00:00:00"
                    fields.pubdate = os.date("!%Y-%m-%d %X")

                success, errMsg = post\update fields
                if success
                    return redirect_to: @url_for "blog_edit", slug: fields.slug or post.slug
                else
                    @session.id = "Error updating post: #{errMsg}"
                    return redirect_to: @url_for "blog_edit", slug: @params.slug

            else
                @session.info = "That post does not exist."
                return redirect_to: @url_for "blog_drafts"
    }

    [drafts: "/drafts"]: =>
        -- for now, lazy, select and show data on all
        -- later I need to paginate this shit
        unless @session.id and (Users\find id: @session.id).admin
            return redirect_to: @url_for "index"

        posts = Posts\select "WHERE true ORDER BY pubdate ASC"

        @html ->
            p ->
                a class: "pure-button", href: @url_for("blog_index"), "Return to Blog"
                a class: "pure-button", href: @url_for("blog_new"), "New Post"
            element "table", class: "pure-table", ->
                tr ->
                    th "Title"
                    th "Status"
                    th "Edit/View"
                for post in *posts
                    tr ->
                        td post.title
                        td Posts.statuses\to_name post.status
                        td ->
                            a href: @url_for("blog_edit", slug: post.slug), "Edit"
                            if post.status == Posts.statuses.published
                                text " | "
                                a href: @url_for("blog_post", slug: post.slug), "View"

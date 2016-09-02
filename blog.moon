lapis = require "lapis"
discount = require "discount"

import respond_to from require "lapis.application"
import slugify, time_ago_in_words from require "lapis.util"

Posts = require "models.Posts"
Users = require "users.models.Users"

class extends lapis.Application
    @path: "/blog"
    @name: "blog_"

    [index: "(/:page[%d])"]: =>
        page = tonumber(@params.page) or 1
        @title = "Guard's Microblog (Page #{page})"

        Paginator = Posts\paginated "WHERE status = ? ORDER BY pubdate DESC", Posts.statuses.published, per_page: 3 -- TODO change to 13 posts
        posts = Paginator\get_page page
        if #posts < 1
            return redirect_to: @url_for("blog_index", page: Paginator\num_pages!)

        @html ->
            p ->
                if page > 1
                    a class: "pure-button", href: @url_for("blog_index", page: page - 1), "Previous"
                else
                    a class: "pure-button pure-button-disabled", "Previous"
                if page < Paginator\num_pages!
                    a class: "pure-button", href: @url_for("blog_index", page: page + 1), "Next"
                else
                    a class: "pure-button pure-button-disabled", "Next"

            for post in *posts
                hr!
                h2 ->
                    a href: @url_for("blog_post", slug: post.slug), post.title .. time_ago_in_words post.pubdate, 2
                if post.text\len! > 200
                    raw discount post.text\sub 1, 200
                    a href: @url_for("blog_post", slug: post.slug), "Read More"
                else
                    raw discount post.text
                --TODO note how many comments from Disqus

    [post: "/post/:slug"]: =>
        if post = Posts\find slug: @params.slug
            @title = post.title
            @html ->
                --TODO some sort of back button that returns to the correct page in blog_index
                h2 time_ago_in_words post.pubdate, 2
                raw discount post.text
                hr!
                --TODO insert a comments section

        return redirect_to: @url_for "blog_index" --TODO error message about post not found

    [new: "/new"]: respond_to {
        GET: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            @html ->
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
                    element "select", name: "status", ->
                        for status in *Posts.statuses
                            if status == Posts.statuses.draft
                                option value: Posts.statuses[status], selected: true, status
                            else
                                option value: Posts.statuses[status], status
                    br!
                    input type: "submit"

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
                return "Failed to create post.", status: 500
    }

    [edit: "/edit/:slug"]: respond_to {
        GET: =>
            unless @session.id and (Users\find id: @session.id).admin
                return redirect_to: @url_for "blog_index"

            if post = Posts\find slug: @params.slug
                @html ->
                    form {
                        action: @url_for "blog_edit", slug: post.slug
                        method: "POST"
                        enctype: "multipart/form-data"
                        class: "pure-form"
                    }, ->
                        text "Title: "
                        input type: "text", name: "title", value: post.title
                        br!
                        textarea cols: 80, rows: 13, name: "text", value: post.text
                        br!
                        element "select", name: "status", ->
                            for status in *Posts.statuses
                                if status == Posts.statuses[post.status]
                                    option value: Posts.statuses[status], selected: true, status
                                else
                                    option value: Posts.statuses[status], status
                        br!
                        input type: "submit"
            else
                return "That post does not exist."

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

                if post\update fields
                    return redirect_to: @url_for "blog_edit", slug: post.slug
                else
                    return "Error updating post.", status: 500

            else
                return "That post does not exist."
    }

    [drafts: "/drafts"]: =>
        -- for now, lazy, select and show data on all
        -- later I need to paginate this shit
        unless @session.id and (Users\find id: @session.id).admin
            return redirect_to: @url_for "index"

        posts = Posts\select "WHERE true"

        @html ->
            element "table", ->
                for post in *posts
                    tr ->
                        td post.title
                        td -> a href: @url_for("blog_edit", slug: post.slug), "Edit"
                        td -> a href: @url_for("blog_post", slug: post.slug), "View"

lapis = require "lapis"

import respond_to from require "lapis.application"

Johns = require "models.Johns"

class extends lapis.Application
    [john_submissions: "/john/submit(/:page[%d])"]: respond_to {
        GET: =>
            @title = "Submit John"
            @html ->
                p "You thought I was joking?! Submit a John!"
                input type: "checkbox", id: "refreshing"
                text " <- click that thing to refresh this page every 10 Lomeli's"
                script -> raw "if (localStorage.getItem('refreshme')=='1') { document.getElementById('refreshing').checked = true; } setInterval(function(){ if (document.getElementById('refreshing').checked) { localStorage.setItem('refreshme', '1'); location.reload(); } else { localStorage.setItem('refreshme', '0'); } }, 10000);"
                form {
                    class: "pure-form"
                    action: @url_for "john_submissions"
                    method: "POST"
                }, ->
                    input type: "text", name: "john"
                    br!
                    input type: "submit", class: "pure-button"
                JOHNS = Johns\paginated "* ORDER BY score DESC", per_page: 20
                page = tonumber(@params.page) or 1
                Johnny = JOHNS\get_page page
                if #Johnny > 0
                    p "Top Johns:"
                    element "table", class: "pure-table pure-table-striped", ->
                        for j in *Johnny
                            tr ->
                                form {
                                    class: "pure-form"
                                    action: @url_for "john_voat"
                                    method: "POST"
                                }, ->
                                    td j.score
                                    td -> a href: @url_for("a_john", JID: j.id), style: "color: grey; font-weight: bold; text-decoration: none;", j.john\sub(1, 50)
                                    td ->
                                        input type: "checkbox", name: "plus"
                                        text "+"
                                    td ->
                                        input type: "checkbox", name: "minus"
                                        text "-"
                                    td ->
                                        input type: "hidden", name: "id", value: j.id
                                        input type: "submit"
                br!
                pages = 20
                for i=1,pages-1
                    a href: @url_for("john_submissions", page: i), i
                    text " | "
                a href: @url_for("john_submissions", page: pages), pages
        POST: =>
            if Jacob = Johns\find john: @params.john
                if Jacob\update { score: Jacob.score + 1 }
                    @session.info = "That John exists, so you has now voted for it! :D"
                    return redirect_to: @url_for "john_submissions"

            john, errrrrrr = Johns\create { john: @params.john }
            if john
                @session.info = "John!"
            else
                @session.info = "Failed to John. :( Because \"#{errrrrrr}\""
            return redirect_to: @url_for "john_submissions"
    }

    [john_voat: "/john/vote-for-president"]: respond_to {
        GET: =>
            @html -> p "What are you doing here?"
        POST: =>
            if @params.plus == "on"
                if john = Johns\find id: @params.id
                    if john\update { score: john.score + 1 }
                        @session.info = "Vote saved."
            if @params.minus == "on"
                if john = Johns\find id: @params.id
                    if john\update { score: john.score - 1 }
                        @session.info = "Vote saved."
            return redirect_to: @url_for "john_submissions"
    }

    [a_john: "/john/id/:JID"]: =>
        if john = Johns\find id: @params.JID
            @html ->
                element "table", class: "pure-table", ->
                    tr ->
                        td john.score
                        td john.john
                        td "someone remind me to put vote buttons here"

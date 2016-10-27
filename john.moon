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
                text " <- click that thing to refresh this page every second"
                script -> raw "if (localStorage.getItem('refreshme')=='1') { document.getElementById('refreshing').checked = true; } setInterval(function(){ if (document.getElementById('refreshing').checked) { localStorage.setItem('refreshme', '1'); location.reload(); } else { localStorage.setItem('refreshme', '0'); } }, 1000);"
                form {
                    class: "pure-form"
                    action: @url_for "john_submissions"
                    method: "POST"
                }, ->
                    input type: "text", name: "john"
                    br!
                    input type: "submit", class: "pure-button"
                JOHNS = Johns\paginated "* ORDER BY score DESC", per_page: 10
                unless page
                    page = 1
                Johnny = JOHNS\get_page page
                if #Johnny > 0
                    p "Recent Johns:"
                    for j in *Johnny
                        element "table", ->
                            tr ->
                                form {
                                    class: "pure-form"
                                    action: @url_for "john_voat"
                                    method: "POST"
                                }, ->
                                    td -> j.john
                                    td ->
                                        input type: "checkbox", name: "plus"
                                        text "+"
                                    td ->
                                        input type: "checkbox", name: "minus"
                                        text "-"
                                    td ->
                                        input type: "hidden", name: "id", value: j.id
                                        input type: "submit"
        POST: =>
            john, errrrrrr = Johns\create { john: @params.john }
            if john
                @session.info = "John!"
            else
                @session.info = "Failed to John. :( Because \"#{errrrrrr}\""
            return redirect_to: @url_for "john_submissions"
    }

    [john_voat: "/john/vote-for-president"]: respond_to {
        GET: =>
            p "What are you doing here?"
        POST: =>
            if @params.plus == "on"
                if john = Johns\find id: @params.id
                    if john\update { score: john.score + 1 }
                        @session.info = "Vote saved."
                        return redirect_to: @url_for "john_submissions"
            if @params.minus == "on"
                if john = Johns\find id: @params.id
                    if john\update { score: john.score - 1 }
                        @session.info = "Vote saved."
                        return redirect_to @url_for "john_submissions"
    }

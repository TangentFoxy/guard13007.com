lapis = require "lapis"

import respond_to from require "lapis.application"

Johns = require "models.Johns"

class extends lapis.Application
    [john_submissions: "/john/submit"]: respond_to {
        GET: =>
            @title = "Submit John"
            @html ->
                p "You thought I was joking?! Submit a John!"
                form {
                    class: "pure-form"
                    action: @url_for "john_submissions"
                    method: "POST"
                }, ->
                    input type: "text", name: "john"
                    br!
                    input type: "submit", class: "pure-button"
                JOHNS = Johns\paginated "* ORDER BY id DESC", per_page: 5
                Johnny = JOHNS\get_page 1
                if #Johnny > 0
                    p "Recent Johns:"
                    for j in *Johnny
                        li j.john
        POST: =>
            john, errrrrrr = Johns\create { @params.john }
            if john
                @session.info = "John!"
            else
                @session.info = "Failed to John. :( Because \"#{errrrrrr}\""
            return redirect_to: @url_for "john_submissions"
    }

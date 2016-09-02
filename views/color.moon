import Widget from require "lapis.html"

class extends Widget
    content: =>
        link rel: "stylesheet", href: @build_url "static/css/pure-min.css"
        link rel: "stylesheet", href: @build_url "static/css/color.css"
        div ->
            form {
                --stuff
            }, ->
                input type: "text", name: "name", value: @hex
                input type: "hidden", name: "code", id: "code", value: @hex
                br!
                button class: "pure-button", onclick: "location.href = \"#{@build_url "colors/"}\" + document.getElementById('code').value;", "Set"
                text " "
                input class: "pure-button", type: "submit", value: "Save"

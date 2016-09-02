import Widget from require "lapis.html"

class extends Widget
    content: =>
        link rel: "stylesheet", href: @build_url "static/css/pure-min.css"
        link rel: "stylesheet", href: @build_url "static/css/color.css"
        script "
            window.onload = function() {
                document.getElementsByTagName('body')[0].style = 'color: #{@hex};'
            }
        "
        div ->
            form {
                --stuff
                class: "pure-form"
            }, ->
                input type: "text", name: "name", @hex
                input type: "hidden", name: "code", id: "code", value: @hex
                br!
                button class: "pure-button", onclick: "location.href = \"#{@build_url "colors/"}\" + document.getElementById('name').value; return false;", "Set"
                text " "
                input class: "pure-button", type: "submit", value: "Save"

import Widget from require "lapis.html"

class extends Widget
    content: =>
        link rel: "stylesheet", href: @build_url "static/css/pure-min.css"
        link rel: "stylesheet", href: @build_url "static/css/color.css"
        script -> raw "
            window.onload = function() {
                document.getElementsByTagName('body')[0].setAttribute('style', 'background: #' + document.getElementById('code').value + ';');
            }
        "
        div ->
            form {
                action: @url_for "colors_hex"
                method: "POST"
                enctype: "multipart/form-data"
                class: "pure-form"
            }, ->
                input style: "color: black;", type: "text", name: "name", id: "name", value: @hex
                input type: "hidden", name: "code", id: "code", value: @hex
                br!
                button class: "pure-button", onclick: "location.href = \"#{@build_url "colors/"}\" + document.getElementById('name').value; return false;", "Set"
                text " "
                input class: "pure-button", type: "submit", value: "Save"

import Widget from require "lapis.html"

Keys = require "models.Keys"

class extends Widget
    content: =>
        keys = Keys\select "* ORDER BY status ASC, game ASC"
        element "table", class: "pure-table pure-table-striped", ->
            tr ->
                th "Game"
                th "Type"
                th "Key"
                th "Status"
                th "Submit"
                th "Recipient"
                th "Delete?"
            for key in *keys
                tr ->
                    form {
                        action: @url_for "gamekeys_list_edit"
                        method: "POST"
                        enctype: "multipart/form-data"
                    }, ->
                        td -> input type: "text", name: "game", value: key.game
                        td ->
                            element "select", name: "type", ->
                                for t in *Keys.types
                                    if t == Keys.statuses[key.type]
                                        option value: Keys.types[t], selected: true, t
                                    else
                                        option value: Keys.types[t], t
                        td -> input type: "text", name: "data", value: key.data
                        td ->
                            element "select", name: "status", ->
                                for s in *Keys.statuses
                                    if s == Keys.statuses[key.status]
                                        option value: Keys.statuses[s], selected: true, s
                                    else
                                        option value: Keys.statuses[s], s
                        td ->
                            input type: "hidden", name: "id", value: key.id
                            input type: "submit", value: "Update"
                        td ->
                            input type: "text", name: "recipient", value: key.recipient
                        td ->
                            input type: "checkbox", name: "delete"
        br!
        a href: @url_for("gamekeys_add"), class: "pure-button", "add key"
        a href: @url_for("gamekeys_list"), class: "pure-button", "key list"

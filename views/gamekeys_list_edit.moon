import Widget from require "lapis.html"

Keys = require "models.Keys"

class extends Widget
    content: =>
        keys = Keys\select "* ORDER BY status ASC, game ASC"
        element "table", ->
            tr ->
                th "Game"
                th "Type"
                th "Key"
                th "Status"
                th "Submit"
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
                                    if t == key.type
                                        option value: Keys.types[t], selected: true, t
                                    else
                                        option value: Keys.types[t], t
                        td -> input type: "text", name: "data", value: key.data
                        td ->
                            element "select", name: "status", ->
                                for s in *Keys.statuses
                                    if s == key.status
                                        option value: Keys.statuses[s], selected: true, s
                                    else
                                        option value: Keys.statuses[s], s
                        td ->
                            input type: "hidden", name: "id", value: key.id
                            input type: "submit", value: "Update"

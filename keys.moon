lapis = require "lapis"

import respond_to from require "lapis.application"

Keys = require "models.Keys"
Users = require "users.models.Users"

class extends lapis.Application
    @path: "/keys"
    @name: "gamekeys_"

    [add: "/add"]: respond_to {
        GET: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            @html ->
                a href: @url_for("gamekeys_list"), "list keys"
                form {
                    class: "pure-form"
                    action: @url_for "gamekeys_add"
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    input type: "text", name: "game", placeholder: "Game"
                    input type: "text", name: "data", placeholder: "Key / URL"
                    element "select", name: "type", ->
                        for t in *Keys.types
                            if t == Keys.types.humblebundle
                                option value: Keys.types[t], selected: true, t
                            else
                                option value: Keys.types[t], t
                    input type: "submit", value: "Submit", class: "pure-button"

        POST: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            key, errMsg = Keys\create {
                user_id: @session.id
                game: @params.game
                data: @params.data
                type: @params.type
                status: Keys.statues.unclaimed
            }

            if key
                return redirect_to: @url_for "gamekeys_list"
            else
                @session.info = "Key submission failed: #{errMsg}"
                return redirect_to: @url_for "gamekeys_add"
    }

    [list: "/list"]: =>
        keys = Keys\select "* WHERE status IS NOT #{Keys.statuses.claimed} ORDER BY game ASC"
        @html ->
            a href: @url_for("gamekeys_add"), "add a key"
            element "table", class: "pure-table pure-table-striped", ->
                tr ->
                    th "Game"
                    th "Type"
                for key in *keys
                    tr ->
                        td key.game
                        td Keys.types[key.type]

    [list_edit: "/list/edit"]: respond_to {
        before: =>
            unless @session.id
                @write redirect_to: @url_for "index"
            user = Users\find id: @session.id
            unless user and user.admin
                @write redirect_to: @url_for "index"

        GET: =>
            render: true

        POST: =>
            key = Keys\find id: @params.id
            key\update {
                game: @params.game
                data: @params.data
                type: @params.type
                status: @params.status
            }

            @info = "Key updated."
            render: true
    }

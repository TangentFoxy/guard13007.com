lapis = require "lapis"

import respond_to from require "lapis.application"

import Keys, Users from require "models"

class extends lapis.Application
    @path: "/keys"
    @name: "gamekeys_"

    [add: "/add"]: respond_to {
        GET: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            @html ->
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
                br!
                a href: @url_for("gamekeys_list"), class: "pure-button", "key list"
                if @session.id and (Users\find id: @session.id).admin
                    a href: @url_for("gamekeys_list_edit"), class: "pure-button", "edit keys"

        POST: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            key, errMsg = Keys\create {
                user_id: @session.id
                game: @params.game
                data: @params.data
                type: @params.type
                status: Keys.statuses.unclaimed
                --recipient: "" -- this is just in case, I don't know if it is needed
            }

            if key
                @session.info = "Key added!"
                return redirect_to: @url_for "gamekeys_list"
            else
                @session.info = "Key submission failed: #{errMsg}"
                return redirect_to: @url_for "gamekeys_add"
    }

    [list: "/list"]: =>
        keys = Keys\select "* WHERE NOT status = #{Keys.statuses.claimed} ORDER BY game ASC"
        @html ->
            h1 "Game Keys"
            p "Keys on this list will either be given out to someone in an upcomming video, or given out to someone requesting them from me. Contact me on Discord if you want a key on this list."
            element "table", class: "pure-table pure-table-striped", ->
                tr ->
                    th "Game"
                    th "Type"
                for key in *keys
                    tr ->
                        td key.game
                        td Keys.types[key.type]
            br!
            a href: @url_for("gamekeys_add"), class: "pure-button", "add key"
            if @session.id and (Users\find id: @session.id).admin
                a href: @url_for("gamekeys_list_edit"), class: "pure-button", "edit keys"

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
            if @params.delete
                key\delete!
            else
                key\update {
                    game: @params.game
                    data: @params.data
                    type: @params.type
                    status: @params.status
                    recipient: @params.recipient
                }

            @info = "Key updated."
            render: true
    }

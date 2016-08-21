lapis = require "lapis"

import respond_to, json_params from require "lapis.application"

Crafts = require "models.Crafts"
Users = require "users.models.Users"

class extends lapis.Application
    @path: "/ksp"
    @name: "ksp_"

    [index: "/"]: =>
        p ->
            a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
            a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"

    "/craft": =>
        redirect_to: @url_for "ksp_craft_list"

    [submit_crafts: "/submit"]: respond_to {
        GET: =>
            @html ->
                form {
                    action: @url_for "ksp_submit_crafts"
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    -- NOTE only craft_name and download_link required

                    -- craft_name, download_link, creator_name
                    -- description, action_groups
                    -- ksp_version, mods_used
                    -- picture
                    -- Submit!
                    h2 "Submit a craft to be reviewed!"
                    p ->
                        text "(If your craft is on "
                        a href: "https://kerbalx.com/", "KerbalX"
                        text ", you only need to enter the craft name and a download link!)"
                    p ->
                        text "Craft Name: "
                        input type: "text", name: "craft_name"
                        text " Download Link: "
                        input type: "text", name: "download_link"
                        text " Creator Name: "
                        input type: "text", name: "creator_name"
                    p "Description:"
                    textarea rows: 4, cols: 60, name: "description"
                    p "Action Groups:"
                    textarea rows: 2, cols: 60, name: "action_groups"
                    p ->
                        text "KSP Version: "
                        input type: "text", name: "ksp_version"
                        text " Mods Used: "
                        input type: "text", name: "mods_used"
                    p ->
                        text "Picture? (URL to an image online!) "
                        input type: "text", name: "picture"
                    p ->
                        input type: "submit"
                a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"

        POST: =>
            --unless @params.creator_name
            --    @params.creator_name = ""
            --unless @params.description
            --    @params.description = "No description provided."
            --unless @params.action_groups
            --    @params.action_groups = ""
            --unless @params.ksp_version
            --    @params.ksp_version = ""
            --unless @params.mods_used
            --    @params.mods_used = ""
            --unless @params.picture
            --    @params.picture = @build_url "/static/img/ksp_craft_no_picture.gif"

            if @session.id
                user_id = @session.id
            else
                user_id = 1

            craft, errMsg = Crafts\create {
                craft_name: @params.craft_name
                download_link: @params.download_link
                creator_name: @params.creator_name
                description: @params.description
                action_groups: @params.action_groups
                ksp_version: @params.ksp_version
                mods_used: @params.mods_used
                picture: @params.picture
                user_id: user_id
            }

            if craft
                return redirect_to: @url_for "ksp_craft", id: craft.id
            else
                return errMsg
    }

    [craft_list: "/crafts(/:page[%d])"]: =>
        page = tonumber(@params.page) or 1

        Paginator = Crafts\paginated "ORDER BY id ASC", per_page: 13
        crafts = Paginator\get_page page
        if #crafts < 1
            return redirect_to: @url_for("ksp_craft_list", page: Paginator\num_pages!)

        @html ->
            link rel: "stylesheet", href: @build_url "static/css/ksp.css"
            p ->
                if page > 1
                    a class: "pure-button", href: @url_for("ksp_craft_list", page: page - 1), "Previous"
                else
                    a class: "pure-button pure-button-disabled", "Previous"
                --text " | "
                if page < Paginator\num_pages!
                    a class: "pure-button", href: @url_for("ksp_craft_list", page: page + 1), "Next"
                else
                    a class: "pure-button pure-button-disabled", "Next"
                a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit"

            element "table", class: "pure-table", ->
                tr ->
                    th style: "width:20%; word-wrap: break-word;", "Craft"
                    th style: "width:20%; word-wrap: break-word;", "Creator"
                    th "Status"
                    th "Notes/Video"
                for craft in *crafts
                    tr ->
                        td style: "width:20%; word-wrap: break-word;", ->
                            a href: @url_for("ksp_craft", id: craft.id), craft.craft_name
                        td style: "width:20%; word-wrap: break-word;", craft.creator_name
                        td style: "width:10%;", class: Crafts.statuses\to_name(craft.status), ->
                            text Crafts.statuses\to_name craft.status
                        td ->
                            if Crafts.statuses.reviewed == craft.status
                                a href: "https://youtube.com/watch?v=#{craft.episode}", target: "_blank", "Watch on YouTube"
                            elseif Crafts.statuses.rejected == craft.status or Crafts.statuses.delayed == craft.status
                                text "#{craft.notes}"

    [craft: "/craft/:id[%d]"]: respond_to {
        GET: =>
            --TODO we need a "back" button or something similar
            if craft = Crafts\find id: @params.id
                if craft.creator_name\len! > 0
                    @title = "#{craft.craft_name} by #{craft.creator_name}"
                else
                    @title = "#{craft.craft_name}"

                @html ->
                    p craft.description --TODO put a fancy box around this (or hr's) ((AND MARKDOWN IT! :D))
                    img src: craft.picture, style: "max-width: inherit;"
                    p -> a href: craft.download_link, "Download" --TODO replace this with something to protect against XSS...
                    p "Action Groups:"
                    pre craft.action_groups
                    p "KSP Version: " .. craft.ksp_version
                    p "Mods Used:"
                    pre craft.mods_used
                    p ->
                        a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                        a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"

                    if @session.id and (Users\find id: @session.id).admin
                        hr!
                        form {
                            action: @url_for "ksp_craft", id: craft.id
                            method: "POST"
                            enctype: "multipart/form-data"
                        }, ->
                            text "Status: "
                            element "select", name: "status", ->
                                option value: 0, "unseen" -- shoddy work-around on my part...
                                for status in *Crafts.statuses
                                    if status == Crafts.statuses[craft.status]
                                        option value: Crafts.statuses[status], selected: true, status
                                    else
                                        option value: Crafts.statuses[status], status
                            text " Episode: "
                            input type: "text", name: "episode", placeholder: craft.episode
                            text " Notes: "
                            input type: "text", name: "notes", placeholder: craft.notes
                            br!
                            input type: "submit"

                        hr!
                        form {
                            action: @url_for "ksp_craft", id: craft.id
                            method: "POST"
                            enctype: "multipart/form-data"
                        }, ->
                            text "Craft name: "
                            input type: "text", name: "craft_name", placeholder: craft.craft_name
                            br!
                            text "Creator name: "
                            input type: "text", name: "creator_name", placeholder: craft.creator_name
                            br!
                            p "Description:"
                            textarea cols: 60, rows: 4, name: "description", placeholder: craft.description
                            br!
                            text "Download link: "
                            input type: "text", name: "download_link", placeholder: craft.download_link
                            br!
                            text "Picture: "
                            input type: "text", name: "picture", placeholder: craft.picture
                            br!
                            p "Action groups:"
                            textarea cols: 60, rows: 2, name: "action_groups", placeholder: craft.action_groups
                            br!
                            text "KSP version: "
                            input type: "text", name: "ksp_version", placeholder: craft.ksp_version
                            br!
                            text "Mods used: "
                            input type: "text", name: "mods_used", placeholder: craft.mods_used
                            br!
                            text "User ID: "
                            input type: "number", name: "user_id", placeholder: craft.user_id
                            br!
                            input type: "submit"

                        hr!
                        form {
                            action: @url_for "ksp_craft", id: craft.id
                            method: "POST"
                            enctype: "multipart/form-data"
                            onsubmit: "return confirm('Are you sure you want to do this?');"
                        }, ->
                            text "Delete craft? "
                            input type: "checkbox", name: "delete"
                            br!
                            input type: "submit"
            else
                return redirect_to: @url_for "ksp_craft_list"

        POST: =>
            if @session.id and (Users\find id: @session.id).admin
                craft = Crafts\find id: @params.id
                if @params.status
                    craft\update {
                        status: Crafts.statuses\for_db tonumber @params.status
                    }
                    --todo info popup
                if @params.episode and @params.episode\len! > 0
                    craft\update {
                        episode: @params.episode
                    }
                    --todo info popup
                elseif @params.notes and @params.notes\len! > 0
                    craft\update {
                        notes: @params.notes
                    }
                    --todo info popup
                elseif @params.delete
                    if craft\delete!
                        return "Craft deleted." --shitty prompt whatever
                    else
                        return status: 500, "Error deleting craft!"

                -- now for the boring stuff
                --TODO I could actually combine this with the above stuff...
                fields = {}
                if @params.craft_name and @params.craft_name\len! > 0
                    fields.craft_name = @params.craft_name
                if @params.creator_name and @params.creator_name\len! > 0
                    fields.creator_name = @params.creator_name
                if @params.description and @params.description\len! > 0
                    fields.description = @params.description
                if @params.download_link and @params.download_link\len! > 0
                    fields.download_link = @params.download_link
                if @params.picture and @params.picture\len! > 0
                    fields.picture = @params.picture
                if @params.action_groups and @params.action_groups\len! > 0
                    fields.action_groups = @params.action_groups
                if @params.ksp_version and @params.ksp_version\len! > 0
                    fields.ksp_version = @params.ksp_version
                if @params.mods_used and @params.mods_used\len! > 0
                    fields.mods_used = @params.mods_used
                if @params.user_id and @params.user_id\len! > 0
                    fields.user_id = tonumber @params.user_id
                craft\update fields

            return redirect_to: @url_for("ksp_craft", id: @params.id)
    }

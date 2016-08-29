lapis = require "lapis"
discount = require "discount"

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
            @title = "Submit a craft to be reviewed!"
            @html ->
                a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                form {
                    action: @url_for "ksp_submit_crafts"
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    -- NOTE only craft_name and download_link required
                    p ->
                        text "(If your craft is on "
                        a href: "https://kerbalx.com/", "KerbalX"
                        text ", you only need to enter the craft name and a link to the craft on KerbalX! DO NOT use a direct download link from KerbalX, those break for some reason.)"
                    p "Please check your download links after submission! Several people have submitted invalid links. I will have a system to try to check for this in the future, but it is not ready yet."
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
                        text "Image URL: "
                        input type: "text", name: "picture"
                    p ->
                        input type: "submit"

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
            unless @params.picture
                @params.picture = @build_url "/static/img/ksp/no_image.png"

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
        @title = "Submitted Craft"
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
                    th "Notes"
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
                            else
                                text "#{craft.notes}"

    [craft: "/craft/:id[%d]"]: respond_to {
        GET: =>
            --TODO we need a "back" button or something similar
            if craft = Crafts\find id: @params.id
                if craft.user_id != 1
                    craft.creator_name = (Users\find id: craft.user_id).name
                if craft.creator_name\len! > 0
                    @title = "#{craft.craft_name} by #{craft.creator_name}"
                else
                    @title = "#{craft.craft_name}"

                @html ->
                    p ->
                        a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                        a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"

                    raw discount craft.description, "nohtml" -- THIS IS SCARY! D:
                    img src: craft.picture
                    if Crafts.statuses.reviewed == craft.status
                        div class: "yt-embed", -> iframe src: "https://www.youtube.com/embed/#{craft.episode}", frameborder: 0, allowfullscreen: true
                    p ->
                        a class: "pure-button", href: craft.download_link, "Download" --TODO replace this with something to protect against XSS...
                        text " KSP Version: " .. craft.ksp_version
                    p "Action Groups:"
                    pre style: "white-space: pre-wrap;", craft.action_groups
                    p "Mods Used:"
                    pre style: "white-space: pre-wrap;", craft.mods_used

                    if @session.id
                        user = Users\find id: @session.id

                        if @session.id == craft.user_id
                            hr!
                            p "Notes from Guard13007: " .. craft.notes

                        if @session.id == craft.user_id or user.admin
                            hr!
                            form {
                                action: @url_for "ksp_craft", id: craft.id
                                method: "POST"
                                enctype: "multipart/form-data"
                            }, ->
                                text "Craft name: "
                                input type: "text", name: "craft_name", placeholder: craft.craft_name
                                br!
                                p "Description:"
                                textarea cols: 60, rows: 5, name: "description", placeholder: craft.description
                                br!
                                text "Download link: "
                                input type: "text", name: "download_link", placeholder: craft.download_link
                                br!
                                text "Image URL: "
                                input type: "text", name: "picture", placeholder: craft.picture
                                br!
                                p "Action groups:"
                                textarea cols: 60, rows: 3, name: "action_groups", placeholder: craft.action_groups
                                br!
                                text "KSP version: "
                                input type: "text", name: "ksp_version", placeholder: craft.ksp_version
                                br!
                                text "Mods used: "
                                input type: "text", name: "mods_used", placeholder: craft.mods_used
                                br!
                                input type: "submit"

                        if user.admin
                            hr!
                            form {
                                action: @url_for "ksp_craft", id: craft.id
                                method: "POST"
                                enctype: "multipart/form-data"
                            }, ->
                                text "Status: "
                                element "select", name: "status", ->
                                    option value: 0, "new" -- shoddy work-around on my part...
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
                                text "Creator name: "
                                input type: "text", name: "creator_name", placeholder: craft.creator_name
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

                    hr!
                    div id: "disqus_thread"
                    script -> raw "
                        var disqus_config = function () {
                            this.page.url = '#{@build_url @url_for "ksp_craft", id: craft.id}';
                            this.page.identifier = '#{@url_for "ksp_craft", id: craft.id}';
                        };
                        (function() {
                            var d = document, s = d.createElement('script');
                            s.src = '//guard13007.disqus.com/embed.js';
                            s.setAttribute('data-timestamp', +new Date());
                            (d.head || d.body).appendChild(s);
                        })();"

            else
                return redirect_to: @url_for "ksp_craft_list"

        POST: =>
            if @session.id
                craft = Crafts\find id: @params.id
                user = Users\find id: @session.id
                fields = {}

                if user.id == craft.user_id or user.admin
                    -- craft name, description, download link, picture, action groups, ksp version, mods used
                    if @params.craft_name and @params.craft_name\len! > 0
                        fields.craft_name = @params.craft_name
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

                if user.admin
                    -- status, episode, notes, creator_name, user_id
                    if @params.status and @params.status\len! > 0
                        fields.status = Crafts.statuses\for_db tonumber @params.status
                    if @params.episode and @params.episode\len! > 0
                        fields.episode = @params.episode
                    if @params.notes and @params.notes\len! > 0
                        fields.notes = @params.notes
                    if @params.creator_name and @params.creator_name\len! > 0
                        fields.creator_name = @params.creator_name
                    if @params.user_id and @params.user_id\len! > 0
                        fields.user_id = tonumber @params.user_id

                    if @params.delete
                        if craft\delete!
                            return "Craft deleted." --shitty prompt whatever, TODO replace with better!
                        else
                            return status: 500, "Error deleting craft!"

                if next fields
                    craft\update fields
                    --TODO should have a prompt about successful update

            return redirect_to: @url_for("ksp_craft", id: @params.id)
    }

lapis = require "lapis"

import respond_to, json_params from require "lapis.application"

Crafts = require "models.Crafts"

class extends lapis.Application
    @path: "/ksp"
    @name: "ksp_"

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
                        text "Picture? (URL to an image online!)"
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
            --unless @params.picture
            --    @params.picture = @build_url "/static/img/ksp_craft_no_picture.gif"

            craft, errMsg = Crafts\create {
                craft_name: @params.craft_name
                download_link: @params.download_link
                creator_name: @params.creator_name
                description: @params.description
                action_groups: @params.action_groups
                ksp_version: @params.ksp_version
                mods_used: @params.mods_used
                picture: @params.picture
            }

            if craft
                return redirect_to: @url_for "ksp_craft", craft.id
            else
                return errMsg
    }

    [craft_list: "/crafts(/:page[%d])"]: =>
        page = @params or 1

        Paginator = Crafts\paginated "ORDER BY id ASC", per_page: 2 --NOTE temporary super low page number for testing!
        crafts = Paginator\get_page page
        @html ->
            ul ->
                for craft in *crafts
                    li ->
                        a href: @url_for "ksp_craft", craft.id -- am I doing this bit right? Oo
                li ->
                    if page > 1
                        a href: @url_for "ksp_craft_list", page - 1
                        text " | "
                    if page < Paginator\num_pages!
                        a href: @url_for "ksp_craft_list", page + 1

    [craft: "/craft/:id[%d]"]: =>
        @html ->
            p "This page temporarily unavailable. :)"

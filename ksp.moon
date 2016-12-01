lapis = require "lapis"
http = require "lapis.nginx.http"

import respond_to from require "lapis.application"

Crafts = require "models.Crafts"
Users = require "users.models.Users"

-- this is probably a bad idea
mt = getmetatable("")
mt.starts = (string, start) ->
    string.sub(string,1,string.len(start))==start

class extends lapis.Application
    @path: "/ksp"
    @name: "ksp_"

    "/*": =>
        redirect_to: @url_for "ksp_craft_list"

    [index: ""]: =>
        redirect_to: @url_for "ksp_craft_list"
        -- Past me, why the fuck did you do this?
        --@html -> p ->
        --    a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
        --    a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"

    "/craft": =>
        redirect_to: @url_for "ksp_craft_list"

    [submit_crafts: "/submit"]: respond_to {
        GET: =>
            @title = "Submit a craft to be reviewed!"
            @html ->
                link rel: "stylesheet", href: @build_url "static/simplemde/simplemde.min.css"
                script src: @build_url "static/simplemde/simplemde.min.js"
                link rel: "stylesheet", href: @build_url "static/highlight/styles/solarized-dark.css"
                script src: @build_url "static/highlight/highlight.pack.js"
                script -> raw "
                    window.onload = function () { var simplemde = new SimpleMDE({
                        autosave: {
                            enabled: true,
                            uniqueId: '#{@url_for "ksp_submit_crafts"}'
                        },
                        indentWithTabs: false,
                        insertTexts: {
                            link: ['[', '](https://)']
                        },
                        parsingConfig: {
                            strikethrough: false
                        },
                        renderingConfig: {
                            singleLineBreaks: false,
                            codeSyntaxHighlighting: true // uses highlight.js
                        }
                    }); }
                "
                a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                text " "
                form {
                    class: "pure-form"
                    action: @url_for "ksp_craft_search"
                    method: "GET"
                    style: "display: inline-block;"
                }, ->
                    input type: "text", name: "query", placeholder: "Search for Crafts"
                    text " "
                    input type: "text", name: "ksp_version", placeholder: "KSP version?"
                    text " "
                    input type: "submit", value: "Search", class: "pure-button"
                br!
                br!
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
                    p "Please check your craft links after submission! Several people have submitted invalid links. I will have a system to try to check for this in the future, but it is not ready yet."
                    p "Note: TinyPic is not supported because they do not have HTTPS support."
                    p ->
                        text "Craft Name: "
                        input type: "text", name: "craft_name"
                        text " Craft Link: "
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
            local status, user_id
            if @session.id
                if (Users\find id: @session.id).admin   -- if an admin is uploading, it is imported
                    status = Crafts.statuses.imported
                    user_id = 0
                else                                    -- else give it the user's name
                    @params.creator_name = (Users\find id: @session.id).name
                    user_id = @session.id
            else
                user_id = 0
            if @params.picture\len! > 0
                if @params.picture\sub(1, 7) == "http://"
                    @params.picture = "https://#{@params.picture\sub 8}"
                t = @params.picture
                if t:starts("https://dropbox.com") or t:starts("https://www.dropbox.com")
                    @session.info = "Dropbox cannot be used to host images."
                    return redirect_to: @url_for "ksp_submit_crafts"
                if t:starts("https://youtube.com") or t:starts("https://www.youtube.com")
                    @session.info = "YouTube cannot be used to host images.."
                    return redirect_to: @url_for "ksp_submit_crafts"
                _, http_status = http.simple @params.picture
                -- TODO log all http_status checks here to compare for what I should allow and disallow
                if http_status == 404 or http_status == 403 or http_status == 500
                    @session.info = "Craft submission failed: Image URL is invalid."
                    return redirect_to: @url_for "ksp_submit_crafts"
                -- TODO attempt to verify and fix Imgur links to albums or pages
            else
                @params.picture = @build_url "/static/img/ksp/no_image.png"

            if @params.download_link\len! > 0
                _, http_status = http.simple @params.download_link
                if http_status == 404 or http_status == 403 or http_status == 500
                    @session.info = "Craft submission failed: Craft link is invalid."
                    return redirect_to: @url_for "ksp_submit_crafts"

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
                status: status or Crafts.statuses.new
            }

            if craft
                return redirect_to: @url_for "ksp_craft", id: craft.id
            else
                @session.info = "Craft submission failed: #{errMsg}"
                return redirect_to: @url_for "ksp_submit_crafts"
    }

    [craft_search: "/search"]: =>
        if @params.query
            local crafts
            if @params.ksp_version and @params.ksp_version\len! > 0
                crafts = Crafts\select "WHERE (craft_name LIKE ? OR creator_name LIKE ? OR description LIKE ?) AND ksp_version LIKE ? ORDER BY id ASC", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.ksp_version.."%"
            else
                crafts = Crafts\select "WHERE craft_name LIKE ? OR creator_name LIKE ? OR description LIKE ? ORDER BY id ASC", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.query.."%"
            if next crafts
                @html ->
                    link rel: "stylesheet", href: @build_url "static/css/ksp.css"
                    a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                    text " "
                    a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"
                    text " "
                    form {
                        class: "pure-form"
                        action: @url_for "ksp_craft_search"
                        method: "GET"
                        style: "display: inline-block;"
                    }, ->
                        input type: "text", name: "query", placeholder: "Search for Crafts"
                        text " "
                        input type: "text", name: "ksp_version", placeholder: "KSP version?"
                        text " "
                        input type: "submit", value: "Search", class: "pure-button"
                    element "table", class: "pure-table", ->
                        tr ->
                            th style: "width:20%; word-wrap: break-word;", "Craft"
                            th style: "width:20%; word-wrap: break-word;", "Creator"
                            th style: "width:12%;", "KSP version"
                            th "Status"
                            th "Notes"
                        for craft in *crafts
                            tr ->
                                --a href: @url_for("ksp_craft", id: craft.id), "#{craft.craft_name} by #{craft.creator_name}"
                                td style: "width:20%; word-wrap: break-word;", ->
                                    a href: @url_for("ksp_craft", id: craft.id), craft.craft_name
                                if craft.user_id != 0
                                    td style: "width:20%; word-wrap: break-word;", (Users\find id: craft.user_id).name
                                else
                                    td style: "width:20%; word-wrap: break-word;", craft.creator_name
                                td style: "width:13%;", craft.ksp_version
                                td style: "width:10%;", class: Crafts.statuses\to_name(craft.status), ->
                                    text Crafts.statuses\to_name craft.status
                                td ->
                                    if Crafts.statuses.reviewed == craft.status
                                        a href: "https://youtube.com/watch?v=#{craft.episode}", target: "_blank", "Watch on YouTube"
                                    else
                                        text craft.notes

            else
                @session.info = "No search results for \"#{@params.query}\" (version \"#{@params.ksp_version}\")"
                return redirect_to: @url_for "ksp_craft_list"

        else
            return redirect_to: @url_for "ksp_craft_list"

    [craft_list: "/crafts(/:page[%d])"]: =>
        page = tonumber(@params.page) or 1
        @title = "Submitted Craft (Page #{page})"

        Paginator = Crafts\paginated "ORDER BY id ASC", per_page: 19
        crafts = Paginator\get_page page
        if #crafts < 1 and Paginator\num_pages! > 0
            return redirect_to: @url_for("ksp_craft_list", page: Paginator\num_pages!)

        @html ->
            link rel: "stylesheet", href: @build_url "static/css/ksp.css"
            if page > 1
                a class: "pure-button", href: @url_for("ksp_craft_list", page: 1), "First"
                a class: "pure-button", href: @url_for("ksp_craft_list", page: page - 1), "Previous"
            else
                a class: "pure-button pure-button-disabled", "First"
                a class: "pure-button pure-button-disabled", "Previous"
            if page < Paginator\num_pages!
                a class: "pure-button", href: @url_for("ksp_craft_list", page: page + 1), "Next"
                a class: "pure-button", href: @url_for("ksp_craft_list", page: Paginator\num_pages!), "Last"
            else
                a class: "pure-button pure-button-disabled", "Next"
                a class: "pure-button pure-button-disabled", "Last"
            text " "
            a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"
            text " "
            form {
                class: "pure-form"
                action: @url_for "ksp_craft_search"
                method: "GET"
                style: "display: inline-block;"
            }, ->
                input type: "text", name: "query", placeholder: "Search for Crafts"
                text " "
                input type: "text", name: "ksp_version", placeholder: "KSP version?"
                text " "
                input type: "submit", value: "Search", class: "pure-button"
            br!
            br!

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
                        if craft.user_id != 0
                            td style: "width:20%; word-wrap: break-word;", (Users\find id: craft.user_id).name
                        else
                            td style: "width:20%; word-wrap: break-word;", craft.creator_name
                        td style: "width:10%;", class: Crafts.statuses\to_name(craft.status), ->
                            text Crafts.statuses\to_name craft.status
                        td ->
                            if Crafts.statuses.reviewed == craft.status
                                a href: "https://youtube.com/watch?v=#{craft.episode}", target: "_blank", "Watch on YouTube"
                            else
                                text craft.notes

            p "What each status means:"
            ul ->
                li "new: I haven't noticed the submission yet"
                li "priority: Next in line to be reviewed."
                li "pending: (Roughly) next in line!"
                li "delayed: I'm holding it back for some reason (see notes)."
                li "reviewed: It's been done! There's a link or embed of the video as well."
                li "rejected: For some reason I won't or can't review the craft. (These are usually deleted after some time.)"
                li "imported: I imported this myself from email or the KerbalX hanger."
                li "old: A submission from a long time ago I imported from email."
            if @session.id
                if user = Users\find id: @session.id
                    if user.admin
                        a href: @url_for("ksp_random"), class: "pure-button", "Random"

    [random: "/random"]: =>
        if @session.id
            if user = Users\find id: @session.id
                if user.admin
                    crafts = Crafts\select "WHERE status = 1"
                    math.randomseed(os.time()) -- this is terrible randomness, figure out how to fix it
                    rand = math.random(1,#crafts)
                    return redirect_to: @url_for "ksp_craft", id: crafts[rand].id
        return redirect_to: @url_for "ksp_craft_list"

    [craft: "/craft/:id[%d]"]: respond_to {
        GET: =>
            if craft = Crafts\find id: @params.id
                if craft.user_id != 0
                    craft.creator_name = (Users\find id: craft.user_id).name
                if craft.creator_name\len! > 0
                    @title = "#{craft.craft_name} by #{craft.creator_name}"
                else
                    @title = "#{craft.craft_name}"

                @html ->
                    script src: @build_url "static/js/marked.min.js"
                    link rel: "stylesheet", href: @build_url "static/highlight/styles/solarized-dark.css"
                    script src: @build_url "static/highlight/highlight.pack.js"
                    script -> raw "
                        marked.setOptions({
                            highlight: function(code) { return hljs.highlightAuto(code).value; },
                            sanitize: true,
                            smartypants: true
                        });
                        hljs.initHighlightingOnLoad();
                    "
                    a class: "pure-button", href: @url_for("ksp_craft_list"), "Craft List"
                    text " "
                    a class: "pure-button", href: @url_for("ksp_submit_crafts"), "Submit Craft"
                    text " "
                    form {
                        class: "pure-form"
                        action: @url_for "ksp_craft_search"
                        method: "GET"
                        style: "display: inline-block;"
                    }, ->
                        input type: "text", name: "query", placeholder: "Search for Crafts"
                        text " "
                        input type: "text", name: "ksp_version", placeholder: "KSP version?"
                        text " "
                        input type: "submit", value: "Search", class: "pure-button"
                    if craft.description\len! < 1
                        br!
                        br!

                    div id: "craft_description"
                    script -> raw "document.getElementById('craft_description').innerHTML = marked('#{craft.description\gsub("\\", "\\\\\\\\")\gsub("'", "\\'")\gsub("\n", "\\n")\gsub("\r", "")\gsub("</script>", "</'+'script>")}');"
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
                    hr!
                    p "Notes from Guard13007: " .. craft.notes

                    if @session.id
                        user = Users\find id: @session.id

                        if @session.id == craft.user_id or user.admin
                            hr!
                            form {
                                action: @url_for "ksp_craft", id: craft.id
                                method: "POST"
                                enctype: "multipart/form-data"
                            }, ->
                                text "Craft name: "
                                input type: "text", name: "craft_name", value: craft.craft_name
                                br!
                                p "Description:"
                                textarea cols: 60, rows: 5, name: "description", placeholder: craft.description
                                br!
                                text "Craft link: "
                                input type: "text", name: "download_link", value: craft.download_link
                                br!
                                text "Image URL: "
                                input type: "text", name: "picture", value: craft.picture
                                br!
                                p "Action groups:"
                                textarea cols: 60, rows: 3, name: "action_groups", placeholder: craft.action_groups
                                br!
                                text "KSP version: "
                                input type: "text", name: "ksp_version", value: craft.ksp_version
                                br!
                                text "Mods used: "
                                input type: "text", name: "mods_used", value: craft.mods_used
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
                                input type: "text", name: "notes", value: craft.notes
                                br!
                                text "Creator name: "
                                input type: "text", name: "creator_name", value: craft.creator_name
                                br!
                                text "User ID: "
                                input type: "number", name: "user_id", value: craft.user_id
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
                            this.page.identifier = '#{@build_url @url_for "ksp_craft", id: craft.id}';
                        };
                        (function() {
                            var d = document, s = d.createElement('script');
                            s.src = '//guard13007.disqus.com/embed.js';
                            s.setAttribute('data-timestamp', +new Date());
                            (d.head || d.body).appendChild(s);
                        })();"

            else
                @session.info = "That craft does not exist."
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
                            @session.info = "Craft deleted."
                            return redirect_to: @url_for "ksp_craft_list"
                        else
                            @session.info = "Error deleting craft!"
                            --return redirect_to: @url_for "ksp_craft", id: @params.id

                if next fields
                    craft\update fields
                    @session.info = "Craft updated."

            return redirect_to: @url_for("ksp_craft", id: @params.id)
    }

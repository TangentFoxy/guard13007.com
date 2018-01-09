class extends lapis.Application
    [craft_list: "/crafts(/:page[%d])"]: =>
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
                        a href: @url_for("ksp_random"), target: "_blank", class: "pure-button", "Random"

    [random: "/random"]: =>
        if @session.id
            if user = Users\find id: @session.id
                if user.admin
                    crafts = Crafts\select "WHERE status = 1 OR status = 7"
                    math.randomseed(os.time()) -- this is terrible randomness, figure out how to fix it
                    rand = math.random(1,#crafts)
                    return redirect_to: @url_for "ksp_craft", id: crafts[rand].id
        return redirect_to: @url_for "ksp_craft_list"

    [craft: "/craft/:id[%d]"]: respond_to {
        GET: =>
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
                                textarea cols: 60, rows: 5, name: "description", craft.description
                                br!
                                text "Craft link: "
                                input type: "text", name: "download_link", value: craft.download_link
                                br!
                                text "Image URL: "
                                input type: "text", name: "picture", value: craft.picture
                                br!
                                p "Action groups:"
                                textarea cols: 60, rows: 3, name: "action_groups", craft.action_groups
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
                            this.page.url = 'https://guard13007.com#{@url_for "ksp_craft", id: craft.id}';
                            this.page.identifier = 'https://guard13007.com:8150#{@url_for "ksp_craft", id: craft.id}';
                        };
                        (function() {
                            var d = document, s = d.createElement('script');
                            s.src = '//guard13007.disqus.com/embed.js';
                            s.setAttribute('data-timestamp', +new Date());
                            (d.head || d.body).appendChild(s);
                        })();"

            -- else
            --     @session.info = "That craft does not exist."
            --     return redirect_to: @url_for "ksp_craft_list"

        POST: =>
            if @session.id
                craft = Crafts\find id: @params.id
                user = Users\find id: @session.id
                fields = {}

                if user.id == craft.user_id or user.admin
                    -- craft name, description, download link, picture, action groups, ksp version, mods used
                    if @params.craft_name and @params.craft_name\len! > 0 and @params.craft_name != craft.craft_name
                        fields.craft_name = @params.craft_name
                    if @params.description and @params.description\len! > 0 and @params.description != craft.description
                        fields.description = @params.description
                    if @params.download_link and @params.download_link\len! > 0 and @params.download_link != craft.download_link
                        fields.download_link = @params.download_link
                    if @params.picture and @params.picture\len! > 0 and @params.picture != craft.picture
                        fields.picture = @params.picture
                    if @params.action_groups and @params.action_groups\len! > 0 and @params.action_groups != craft.action_groups
                        fields.action_groups = @params.action_groups
                    if @params.ksp_version and @params.ksp_version\len! > 0 and @params.ksp_version != craft.ksp_version
                        fields.ksp_version = @params.ksp_version
                    if @params.mods_used and @params.mods_used\len! > 0 and @params.mods_used != craft.mods_used
                        fields.mods_used = @params.mods_used

                if user.admin
                    -- status, episode, notes, creator_name, user_id
                    if @params.status and @params.status\len! > 0 and @params.status != craft.status
                        fields.status = Crafts.statuses\for_db tonumber @params.status
                    if @params.episode and @params.episode\len! > 0 and @params.episode != craft.episode
                        fields.episode = @params.episode
                    if @params.notes and @params.notes\len! > 0 and @params.notes != craft.notes
                        fields.notes = @params.notes
                    if @params.creator_name and @params.creator_name\len! > 0 and @params.creator_name != craft.creator_name
                        fields.creator_name = @params.creator_name
                    if @params.user_id and @params.user_id\len! > 0 and @params.user_id != craft.user_id
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

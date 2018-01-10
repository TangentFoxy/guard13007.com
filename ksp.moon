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

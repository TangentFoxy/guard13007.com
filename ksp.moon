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

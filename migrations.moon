import create_table, types, drop_table from require "lapis.db.schema"

{
    [1]: =>
        print "Test first migration just to stop erroring worked?"
    [2]: =>
        create_table "planes", {
            {"id", types.serial primary_key: true}
            {"craft_name", types.text}
            {"download_link", types.text unique: true}
            {"description", types.text}
            {"mods_used", types.text}
            {"creator_name", types.varchar}
            {"ksp_version", types.varchar}
            {"status", types.integer default: 0}   -- enum for whether I've done anything or not
            {"action_groups", types.text}
            {"episode", types.varchar}             -- video ID, internal use
            {"rejection_reason", types.text default: "not rejected"}
            {"picture", types.text}                -- URL to image or imgur album
            --NOTE this is how imgur embeds work (I think) <blockquote class="imgur-embed-pub" lang="en" data-id="gw22T2m"><a href="//imgur.com/gw22T2m">Some of us black people are fighting for our community from within.</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [3]: =>
        drop_table "planes"
        create_table "crafts", {
            {"id", types.serial primary_key: true}
            {"craft_name", types.text}
            {"download_link", types.text unique: true}
            {"description", types.text default: "No description provided."}
            {"mods_used", types.text}
            {"creator_name", types.varchar}
            {"ksp_version", types.varchar}
            {"status", types.integer default: 0}   -- enum for whether I've done anything or not
            {"action_groups", types.text}
            {"episode", types.varchar}             -- video ID, internal use
            {"rejection_reason", types.text}
            {"picture", types.text}                -- URL to image or imgur album
            --NOTE this is how imgur embeds work (I think) <blockquote class="imgur-embed-pub" lang="en" data-id="gw22T2m"><a href="//imgur.com/gw22T2m">Some of us black people are fighting for our community from within.</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

            {"created_at", types.time}
            {"updated_at", types.time}
        }
}

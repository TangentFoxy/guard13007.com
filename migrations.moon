db = require "lapis.db"

import create_table, types, drop_table, add_column, rename_column from require "lapis.db.schema"

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

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [4]: =>
        drop_table "crafts"
        create_table "crafts", {
            {"id", types.serial primary_key: true}
            {"craft_name", types.text}
            {"download_link", types.text unique: true}
            {"description", types.text default: "No description provided."}
            {"mods_used", types.text default: ""}
            {"creator_name", types.varchar default: ""}
            {"ksp_version", types.varchar default: ""}
            {"status", types.integer default: 0}                -- enum for whether I've done anything or not
            {"action_groups", types.text default: ""}
            {"episode", types.varchar default: "Cztk_cYxFSI"}   -- video ID, internal use (default is Ep.50)
            {"rejection_reason", types.text default: ""}
            {"picture", types.text default: "https://guard13007.com/static/img/ksp_craft_no_picture.gif"} -- this is stupid
            --NOTE this is how imgur embeds work (I think) <blockquote class="imgur-embed-pub" lang="en" data-id="gw22T2m"><a href="//imgur.com/gw22T2m">Some of us black people are fighting for our community from within.</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [5]: =>
        create_table "users", {
            {"id", types.serial primary_key: true}
            {"name", types.varchar unique: true}
            {"salt", types.text}
            {"digest", types.text}
            {"admin", types.boolean default: false}
        }
    [6]: =>
        return true --drop_table "user" --fuck, I messed up
    [7]: =>
        drop_table "users"
        create_table "users", {
            {"id", types.serial primary_key: true}
            {"name", types.varchar unique: true}
            {"digest", types.text}
            {"admin", types.boolean default: false}
        }
    [8]: =>
        add_column "crafts", "user_id", types.foreign_key default: 1
    [9]: =>
        rename_column "crafts", "rejection_reason", "notes"
    [10]: =>
        db.query "ALTER TABLE crafts ALTER picture SET DEFAULT 'https://guard13007.com/static/img/ksp/no_image.png'"
    [11]: =>
        create_table "posts", {
            {"id", types.serial primary_key: true}
            {"title", types.text unique: true}
            {"slug", types.text unique: true}
            {"text", types.text default: ""}
            {"status", types.integer default: 1}
            {"pubdate", types.time}

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [12]: =>
        return true -- I fucked up migrations stuff again
    [13]: =>
        drop_table "posts"
        create_table "posts", {
            {"id", types.serial primary_key: true}
            {"title", types.text unique: true}
            {"slug", types.text unique: true}
            {"text", types.text default: ""}
            {"status", types.integer default: 1}
            {"pubdate", types.time}

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [14]: =>
        create_table "colors", {
            {"id", types.serial primary_key: true}
            {"code", types.varchar unique: true}
        }
    [15]: =>
        add_column "colors", "name", types.text unique: true
    [16]: =>
        drop_table "colors"
    [17]: =>
        db.update "crafts", {
          user_id: 0 --what to change
        }, {
          user_id: 1 --matching what
        }
    [18]: =>
        create_table "johns", {
            {"id", types.serial primary_key: true}
            {"john", types.text}

            {"created_at", types.time}
            {"updated_at", types.time}
        }
    [19]: =>
        add_column "johns", "score", types.integer default: 0
}

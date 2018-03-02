db = require "lapis.db"
import create_table, types, drop_table, add_column, rename_column, rename_table from require "lapis.db.schema"
import make_migrations, autoload from require "locator"
import settings from autoload "utility"

make_migrations {
  [1]: =>
    return true
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
      user_id: 0 --change to
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
  [20]: =>
    create_table "cards", {
      {"id", types.serial primary_key: true}
      {"user_id", types.foreign_key}
      {"title", types.text}
      {"artwork", types.text}
      {"description", types.text}
      {"point_value", types.integer}
      {"rating", types.integer}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
    create_table "card_votes", {
      {"user_id", types.foreign_key}
      {"card_id", types.foreign_key}
    }
  [21]: =>
    drop_table "cards"
    create_table "cards", {
      {"id", types.serial primary_key: true}
      {"user_id", types.foreign_key}
      {"title", types.text default: ""}
      {"artwork", types.text default: "https://guard13007.com/static/img/aaa-1x1.png"}
      {"description", types.text default: ""}
      {"point_value", types.integer default: 0}
      {"rating", types.integer default: 0}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
  [22]: =>
    db.query "UPDATE cards SET artwork = 'https://guard13007.com/static/img/aaa-1x1.png' WHERE artwork = ''"
  [23]: =>
    create_table "keys", {
      {"id", types.serial primary_key: true}
      {"user_id", types.foreign_key}
      {"game", types.text}
      {"data", types.text}
      {"type", types.integer}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
  [24]: =>
    add_column "keys", "status", types.integer default: 1
  [25]: =>
    add_column "keys", "recipient", types.text default: ""
  [26]: =>
    rename_table "posts", "old_posts"
  [27]: =>
    create_table "posts", {
      {"id", types.serial primary_key: true}
      {"title", types.text unique: true}
      {"slug", types.text unique: true}
      {"url", types.text null: true}

      {"text", types.text default: ""}
      {"preview_text", types.text default: ""}

      {"status", types.integer default: 1}
      {"type", types.integer default: 0}

      {"published_at", types.time}
      {"created_at", types.time}
      {"updated_at", types.time}
    }
  [28]: =>
    rename_column "posts", "url", "splat"
    add_column "posts", "html", types.text default: ""
    add_column "posts", "preview_html", types.text default: ""

    create_table "tags", {
      {"id", types.serial primary_key: true}
      {"name", types.text unique: true}
    }
    create_table "post_tags", {
      {"post_id", types.foreign_key}
      {"tag_id", types.foreign_key}
    }
  [29]: =>
    db.update "posts", {
      type: 7 --change to
    }, {
      type: 9 --matching what
    }
  [30]: =>
    rename_column "crafts", "craft_name", "name"
    rename_column "crafts", "creator_name", "creator"
  [31]: =>
    markdown = require "markdown"
    import Posts, OldPosts from require "models"
    oldPosts = OldPosts\select "WHERE true"

    for oldPost in *oldPosts
      post, err = Posts\create {
        title: oldPost.title
        slug: oldPost.slug
        text: oldPost.text
        preview_text: oldPost.text\sub 1, 500
        status: oldPost.status
        type: Posts.types["blog post"]
        published_at: oldPost.pubdate
        created_at: oldPost.created_at
        updated_at: oldPost.updated_at
        html: markdown oldPost.text
        preview_html: markdown oldPost.text\sub 1, 500
      }
      error err unless post
  [32]: =>
    create_table "craft_tags", {
      {"craft_id", types.foreign_key}
      {"tag_id", types.foreign_key}
    }
  [33]: =>
    rename_table "users", "old_users"
  [34]: =>
    -- this is copied from users migration 1
    create_table "users", {
      {"id", types.serial primary_key: true}
      {"name", types.varchar unique: true}
      {"email", types.text unique: true}
      {"digest", types.text}
      {"admin", types.boolean default: false}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
    create_table "sessions", {
      {"user_id", types.foreign_key}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
  [1519029724]: =>
    settings["users.require-email"] = false
    settings["users.require-unique-email"] = false
    settings.save!

    import Users, OldUsers, Crafts, Cards, CardVotes, Keys from require "models"
    oldUsers = OldUsers\select "WHERE true"

    for oldUser in *oldUsers
      user, err = Users\create {
        name: oldUser.name
        digest: oldUser.digest
        admin: oldUser.admin
      }
      error err unless user
      if oldUser.id != user.id
        for Model in *{Crafts, Cards, CardVotes, Keys}
          models = Model\select "WHERE user_id = ?", oldUser.id
          for item in *models
            item\update user_id: user.id
  [1519264124]: =>
    -- import Crafts from require "models"
    -- crafts = Crafts\select "WHERE picture LIKE ?", "%/static/img/ksp/no_image.png" -- NOTE might be wrong
    -- for craft in *crafts
    --   craft\update picture: "https://guard13007.com/static/img/ksp/no_image.png"
    return true -- this migration can't run outside of the browser :/
  [1519267020]: =>
    create_table "categories", {
      {"id", types.serial primary_key: true}
      {"name", types.text unique: true}
      {"parent_id", types.foreign_key null: true}
    }
    create_table "post_categories", {
      {"post_id", types.foreign_key}
      {"category_id", types.foreign_key}
    }
  [1519419901]: =>
    rename_table "users", "users2"
    rename_table "old_users", "users"
    add_column "users", "email", types.text null: true
  [1520001591]: =>
    rename_table "keys", "game_keys"
    rename_column "game_keys", "game", "item"
    rename_column "game_keys", "data", "key"

  -- []: =>
  --   create_table "software_projects", {
  --     {"id", types.serial primary_key: true}
  --     {"title", types.varchar unique: true}
  --     {"tagline", types.text}
  --     {"external_url", types.text null: true}
  --     {"primary_language", types.varchar null: true}
  --     {"description", types.text}
  --     {"private", types.boolean default: true}
  --     {"completeness", types.varchar default: "Prototype"}
  --     {"code_quality", types.integer default: 0} -- enum
  --     {"type", types.integer default: 0}         -- enum
  --
  --     {"created_at", types.time}
  --     {"updated_at", types.time}
  --   }
  --   create_table "programming_languages", {
  --     {"id", types.serial primary_key: true}
  --     {"name", types.varchar unique: true}
  --   }
  --   create_table "project_languages", {
  --     {"project_id", types.foreign_key}
  --     {"language_id", types.foreign_key}
  --   }
  -- TODO make a migration searching for CraftTags instances pointing to deleted Crafts and deletes them
}

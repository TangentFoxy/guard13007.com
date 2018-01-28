import create_table, create_index, types, add_column, rename_column from require "lapis.db.schema"

{
  [1]: =>
    create_table "e621_images", {
      {"id", types.integer primary_key: true}
      -- tags (stored in e621_tags / e621_image_tags)
      -- locked_tags (stored in e621_tags / e621_locked_image_tags)
      {"description", types.text}
      {"created_at_s", types.integer}
      {"created_at_n", types.integer}
      -- null in case this can be non-existant
      {"creator_id", types.integer null: true}
      -- null in case this can be non-existant
      {"author", types.text null: true}
      {"change", types.integer} -- don't think this is important
      -- source (ignored, because we use the array instead) (can be null!)
      {"score", types.integer}
      {"fav_count", types.integer}
      -- should be unique, but allows null because of deleted images
      {"md5", types.varchar null: true}
      -- allows null because of deleted images
      {"file_size", types.integer null: true}
      -- should be unique, except for deleted images
      {"file_url", types.text}
      -- allows null because of deleted images
      {"file_ext", types.varchar null: true}
      -- should be unique, except for deleted images
      {"preview_url", types.text unique: true}
      -- allows null because of deleted images
      {"preview_width", types.integer null: true}
      -- allows null because of deleted images
      {"preview_height", types.integer null: true}
      -- should be unique, but allows null because of deleted images
      {"sample_url", types.text null: true}
      -- allows null because of deleted images
      {"sample_width", types.integer null: true}
      -- allows null because of deleted images
      {"sample_height", types.integer null: true}
      {"rating", types.integer} -- enum
      {"status", types.integer} -- enum
      {"width", types.integer}
      {"height", types.integer}
      {"has_comments", types.boolean}
      {"has_notes", types.boolean}
      -- default because null is possible
      {"has_children", types.boolean default: false}
      -- children (stored in e621_children) (can be null!)
      {"parent_id", types.integer null: true}
      -- artist (stored in e621_artists / e621_image_artists)
      -- sources (stored in e621_sources / e621_image_sources) (can be null!)
      {"delreason", types.text null: true} -- only on deleted images

      {"created_at", types.time}
      {"updated_at", types.time}

      -- this is used to mark an image that didn't import correctly
      {"dirty", types.boolean default: false}
    }

    create_table "e621_tags", {
      {"id", types.integer primary_key: true}
      {"name", types.text unique: true}
    }
    create_table "e621_image_tags", {
      {"image_id", types.foreign_key}
      {"tag_id", types.foreign_key}
    }
    create_table "e621_locked_image_tags", {
      {"image_id", types.foreign_key}
      {"tag_id", types.foreign_key}
    }

    create_table "e621_image_children", {
      {"image_id", types.foreign_key}
      {"child_id", types.foreign_key}
    }

    create_table "e621_artists", {
      {"id", types.integer primary_key: true}
      {"name", types.text unique: true}
    }
    create_table "e621_image_artists", {
      {"image_id", types.foreign_key}
      {"artist_id", types.foreign_key}
    }

    create_table "e621_sources", {
      {"id", types.integer primary_key: true}
      {"value", types.text unique: true}
    }
    create_table "e621_image_sources", {
      {"image_id", types.foreign_key}
      {"source_id", types.foreign_key}
    }

  [2]: =>
    create_table "images", {
      {"id", types.integer primary_key: true}
      {"md5", types.varchar unique: true}

      -- not unique / null allowed for future expansion
      -- references e621_images table
      {"e621id", types.foreign_key null: true}

      {"created_at", types.time}
      {"updated_at", types.time}
    }

    create_table "tags", {
      {"id", types.integer primary_key: true}
      {"name", types.text unique: true}
    }
    create_table "image_tags", {
      {"image_id", types.foreign_key}
      {"tag_id", types.foreign_key}
    }
}

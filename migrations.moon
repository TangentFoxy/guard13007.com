db = require "lapis.db"
import create_table, types, add_column, rename_column, create_index, drop_index from require "lapis.db.schema"

import autoload from require "locator"
import settings from autoload "utility"

{
  [1]: =>
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

  [1518430372]: =>
    add_column "sessions", "id", types.serial primary_key: true
    rename_column "sessions", "created_at", "opened_at"
    rename_column "sessions", "updated_at", "closed_at"

    create_index "users", "id", unique: true
    create_index "users", "name", unique: true
    create_index "users", "email", unique: true

    create_index "sessions", "id", unique: true

  [1518968812]: =>
    settings["users.allow-sign-up"] = true
    settings["users.allow-name-change"] = true
    settings["users.admin-only-mode"] = false
    settings["users.require-email"] = true
    settings["users.require-unique-email"] = true
    settings["users.allow-email-change"] = true
    settings["users.session-timeout"] = 60 * 60 * 24 -- default is one day

    settings["users.minimum-password-length"] = 12
    settings["users.maximum-character-repetition"] = 6
    settings["users.bcrypt-digest-rounds"] = 12
    -- settings["users.password-check-fn"] = nil -- should return true if passes, falsy and error message if fails
    settings.save!

    drop_index "users", "email" -- replacing because it was a unique index
    db.query "ALTER TABLE users DROP CONSTRAINT users_email_key"
    create_index "users", "email"
}

import create_table, types, create_index from require "lapis.db.schema"

import autoload from require "locator"
import settings from autoload "utility"

{
  [1519992142]: =>
    create_table "githook_logs", {
      {"id", types.serial primary_key: true}
      {"success", types.boolean default: true}
      {"exit_codes", types.text null: true}
      {"log", types.text null: true}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
    create_index "githook_logs", "id", unique: true
    create_index "githook_logs", "success"
    settings["githook.save_logs"] = true
    settings["githook.save_on_success"] = true
    settings["githook.allow_get"] = true
    settings["githook.run_without_auth"] = false
    -- settings["githook.branch"] = "master"
    settings.save!
}

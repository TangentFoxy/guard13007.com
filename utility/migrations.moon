import create_table, types, create_index from require "lapis.db.schema"

{
  [1518948992]: =>
    create_table "settings", {
      {"name", types.varchar primary_key: true, unique: true}
      {"value", types.text null: true}

      {"created_at", types.time}
      {"updated_at", types.time}
    }
    create_index "settings", "name", unique: true
}

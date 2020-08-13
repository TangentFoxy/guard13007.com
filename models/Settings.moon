import Model from require "lapis.db.model"

class Settings extends Model
  @primary_key: "name"
  @timestamp: true

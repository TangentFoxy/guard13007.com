import Model from require "lapis.db.model"

class Settings extends Model
  @timestamp: true
  @primary_key: "name"

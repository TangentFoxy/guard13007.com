import Model from require "lapis.db.model"

class Images extends Model
  @timestamp: true

  @constraints: {
    md5: (value) =>
      if value and Images\find md5: value
        return "An image with that MD5 already exists."
  }

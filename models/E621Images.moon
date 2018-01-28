import Model, enum from require "lapis.db.model"

class E621Images extends Model
  @timestamp: true

  @ratings: enum {
    e: 1
    q: 2
    s: 3
  }

  @statuses: enum {
    active: 1
    flagged: 2
    pending: 3
    deleted: 4
  }

  @constraints: {
    md5: (value) =>
      if value and E621Images\find md5: value
        return "An image with that MD5 already exists."
  }

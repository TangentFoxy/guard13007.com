import Model, enum from require "lapis.db.model"

class OldPosts extends Model
  @timestamp: true

  @statuses: enum {
    draft: 1
    published: 2
  }

  @constraints: {
    title: (value) =>
      if not value or value\len! < 1
        return "Must have a title."
      if OldPosts\find title: value
        return "A post with that title has already been created."
    slug: (value) =>
      if OldPosts\find slug: value
        return "A post with too similar a title has already been created."
    }

import Model, enum from require "lapis.db.model"

class Posts extends Model
  @timestamp: true

  @statuses: enum {
    draft: 1
    published: 2
    scheduled: 3 -- /static/js/posts/edit.js relies on the numerical value
  }

  @types: enum {
    undefined: 0 -- views/posts.edit relies on the string value
    "game (page)": 1
    -- "video post (mine)": 2
    -- "art post (mine)": 3
    "game-specific videos (page)": 4
    "playlist page (mine)": 5
    -- "review post (mine)": 6
    "software library page (mine)": 7
    "tutorial post/page (mine)": 8
    "stand-alone page (splat)": 9 -- /static/js/posts/edit.js relies on the numerical value
    -- "site update (post)": 10
    -- "music post (other)": 11
    "blog post": 12
  }

  @constraints: {
    title: (value) =>
      if not value or value\len! < 1
        return "Must have a title."
      if Posts\find title: value
        return "A post with that title has already been created."
    slug: (value) =>
      if Posts\find slug: value
        return "A post with too similar a title has already been created."
    }

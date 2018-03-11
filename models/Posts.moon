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
    "game page (mine)": 1
    "blog post": 2
    "game-specific videos page (other's)": 3
    "playlist page (mine)": 4
    "software page (mine)": 5
    "tutorial post/page (mine)": 6
    "stand-alone page": 7
    -- "video post (mine)": 2
    -- "art post (mine)": 3
    -- "review post (mine)": 6
    -- "site update (post)": 10
    -- "music post (other)": 11
  }

  get_previous: =>
    posts = Posts\select "WHERE published_at < ? AND status = ? AND splat IS NULL ORDER BY published_at DESC LIMIT 1", @published_at, Posts.statuses.published
    return posts[1]
  get_next: =>
    posts = Posts\select "WHERE published_at > ? AND status = ? AND splat IS NULL ORDER BY published_at LIMIT 1", @published_at, Posts.statuses.published
    return posts[1]

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

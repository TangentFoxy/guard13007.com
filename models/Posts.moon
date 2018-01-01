import Model, enum from require "lapis.db.model"

class Posts extends Model
  @timestamp: true

  @statuses: enum {
    draft: 1
    published: 2
    scheduled: 3
  }

  @types: enum {
    undefined: 0 -- for imported posts / drafts / undecided
    my_game: 1
    my_video: 2
    my_art: 3
    game_page: 4
    my_playlist: 5
    my_review: 6
    my_library: 7
    my_tutorial: 8
    stand_alone: 9 -- for posts with custom url
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

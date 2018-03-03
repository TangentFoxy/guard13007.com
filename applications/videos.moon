lapis = require "lapis"

import Videos from require "models"

class extends lapis.Application
  @path: "/videos"
  @name: "videos_"

  [index: ""]: =>
    @videos = Videos\select "* ORDER BY published_at DESC" -- TODO paginated
    return render: "videos.index"

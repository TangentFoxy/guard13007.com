import Widget from require "lapis.html"

class KSPCraftsStats extends Widget
  content: =>
    for name, count in pairs @craft_counts
      progress class: "progress", value: count, max: @craft_counts.all

    progress class: "progress", value: @tag_counts.craft_with_tags, max: @craft_counts.all
    progress class: "progress", value: @tag_counts.tags, max: @tag_counts.tags

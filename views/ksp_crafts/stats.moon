import Widget from require "lapis.html"

class KSPCraftsStats extends Widget
  content: =>
    for name, count in pairs @craft_counts
      p name
      progress class: "progress", value: count, max: @craft_counts.all

    hr!

    p "Craft with Tags"
    progress class: "progress", value: @tag_counts.craft_with_tags, max: @craft_counts.all
    p "Number of Tags"
    progress class: "progress", value: @tag_counts.tags, max: @tag_counts.tags

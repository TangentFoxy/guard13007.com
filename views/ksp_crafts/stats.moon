import Widget from require "lapis.html"
import insert, sort from table

class KSPCraftsStats extends Widget
  content: =>
    order = {}
    for name in pairs @craft_counts
      insert order, name
    sort order

    for name in *order
      count = @craft_counts[name]
      p "#{name\sub(1, 1)\upper!}#{name\sub(2)\gsub "_", " "} Craft"
      progress class: "progress", value: count, title: count, max: @craft_counts.all

    hr!

    p "Tagged Craft"
    progress class: "progress", value: @tag_counts.craft_with_tags, max: @craft_counts.all
    p "There are #{@tag_counts.tags} tags."

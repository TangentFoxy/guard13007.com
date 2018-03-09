import Widget from require "lapis.html"
import insert, sort, remove from table

progress_classes = {
  imported: "is-warning"
  pending: "is-success"
  priority: "is-primary"
  rejected: "is-danger"
  reviewed: "is-link"
}

class KSPCraftsStats extends Widget
  content: =>
    order = {}
    for name in pairs @craft_counts
      insert order, name
    sort order

    remove order, 1
    for name in *order
      count = @craft_counts[name]
      p "#{name\sub(1, 1)\upper!}#{name\sub(2)\gsub "_", " "} Craft"

      if progress_classes[name]
        progress class: "progress #{progress_classes[name]}", value: count, title: count, max: @craft_counts.all
      else
        progress class: "progress", value: count, title: count, max: @craft_counts.all

    p "Tagged Craft"
    progress class: "progress", value: @tag_counts.craft_with_tags, max: @craft_counts.all
    p "There are #{@tag_counts.tags} tags."

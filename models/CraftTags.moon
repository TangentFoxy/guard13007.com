import Model from require "lapis.db.model"
import Tags from require "models"

class CraftTags extends Model
  to_string: (tab) =>
    tags = Tags\select "WHERE id IN (SELECT tag_id FROM craft_tags WHERE craft_id = ?) ORDER BY name ASC", tab.craft_id

    for tag in *tags
      tag = tag.name

    return table.concat tags, " "

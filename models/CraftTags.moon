import Model from require "lapis.db.model"
import Tags from require "models"

class CraftTags extends Model
  @primary_key: "craft_id"

  hash: (tab) =>
    tags = Tags\select "WHERE id IN (SELECT tag_id FROM craft_tags WHERE craft_id = ?)", tab.craft_id
    result = {}
    for tag in *tags
      result[tag.name] = true
    return result

  list: (tab) =>
    tags = Tags\select "WHERE id IN (SELECT tag_id FROM craft_tags WHERE craft_id = ?) ORDER BY name ASC", tab.craft_id
    result = {}
    for tag in *tags
      table.insert result, tag.name
    return result

  to_string: (tab) =>
    return table.concat @list(tab), " "

import Model from require "lapis.db.model"

-- import TagRelations from require "models"
import assert_error from require "lapis.application"
import singularize from require "lapis.util"
import locate from require "locator"
import split from locate "gstring"
import invert from locate "gtable"
import insert, concat from table

class Tags extends Model
  get: (item) =>
    -- if "table" == type relation_id
    --   relation_id = relation_id.id
    -- tags = @select "WHERE id IN (SELECT tag_id FROM tag_relations WHERE relation_id = ?) ORDER BY name ASC", relation_id
    relation_name = item.__class\singular_name!
    tags = assert_error @select "WHERE id IN (SELECT tag_id FROM #{relation_name}_tags WHERE #{relation_name}_id = ?) ORDER BY name ASC", item.id
    result = {}
    for tag in *tags
      insert result, tag.name
    return result

  set: (item, tag_str) =>
    relation_name = item.__class\singular_name!
    RelationModel = require("models")["#{singularize item.__class.__name}Tags"]
    oldTags = invert @get item
    newTags = invert split tag_str
    addedTags, removedTags = {}, {}

    for tag in pairs newTags
      unless oldTags[tag]
        addedTags[tag] = true
    for tag in pairs oldTags
      unless newTags[tag]
        removedTags[tag] = true

    for name in pairs addedTags
      tag = assert_error Tags\find(:name) or Tags\create(:name)
      assert_error RelationModel\create tag_id: tag.id, ["#{relation_name}_id"]: item.id
    for name in pairs removedTags
      tag = assert_error RelationModel\find ["#{relation_name}_id"]: item.id, tag_id: (Tags\find(:name)).id
      assert_error tag\delete!

    if nil == next(addedTags) and nil == next(removedTags)
      return false
    else
      return true

  remove: (item) =>
    relation_name = item.__class\singular_name!
    RelationModel = require("models")["#{singularize item.__class.__name}Tags"]
    for tag in *(assert_error RelationModel\select "WHERE #{relation_name}_id = ?", item.id)
      assert_error tag\delete!

  __tostring: (item) =>
    return concat @get(item), ""

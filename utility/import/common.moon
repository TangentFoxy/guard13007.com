import decode, null from require "cjson"

{
  fix_null: (value) ->
    if value == null or value == ""
      return nil
    else
      return value
}

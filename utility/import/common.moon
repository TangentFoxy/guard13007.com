import decode, null from require "cjson"

{
  :decode
  fix_null: (value) ->
    if value == null or value == ""
      return nil
    else
      return value
}

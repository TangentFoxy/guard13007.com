exists = (file_path) ->
  handle = io.open file_path, "r"
  if handle
    handle\close!
    return true
  return false

{
  :exists
}

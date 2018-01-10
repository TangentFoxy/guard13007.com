invert: (tab) ->
  new = {}
  for k,v in pairs tab
    new[v] = k
  return new

{
  :invert
}

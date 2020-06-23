-- appends n arrays to the end of the first array
append = (tab1, ...) ->
  for n = 1, select "#", ...
    tab2 = select n, ...
    for i = 1, #tab2
      tab1[#tab1+1] = tab2[i]
  return tab1

-- returns a new table shallow copying data from all arguments
--  later arguments overwrite any keys in earlier arguments
--  ignores non-table arguments (skipping them)
shallow_copy = (...) ->
  new = {}
  for n = 1, select "#", ...
    tab = select n, ...
    if "table" == type tab
      for k,v in pairs tab
        new[k] = v
  return new

-- returns a new table with flipped keys and values
invert = (tab) ->
  new = {}
  for key, value in pairs tab
    new[value] = key
  return new

{
  :append
  :shallow_copy
  :invert
}

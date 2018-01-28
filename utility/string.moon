import insert from table

-- splits string by spaces into a table of strings
--  (handles bad spacing and duplicate substrings)
split = (str) ->
  tab1, tab2 = {}, {}
  for word in str\gmatch "%S+"
    tab1[word] = true
  for word in pairs tab1
    insert tab2, word
  return tab2

-- splits string by commas into a table of strings
--  (expects a well-formated string!)
comma_split = (str) ->
  tab = {}
  for word in str\gmatch "[^,]+"
    insert tab, word
  return tab

{
  :split
  :comma_split
}

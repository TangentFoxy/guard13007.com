-- splits string into table by spaces
--  (handles duplicate spacing and tab/newline spacing as well)
split = (str) ->
  tab = {}
  for word in str\gmatch "%S+"
    table.insert tab, word
  return tab

-- bool: does str1 start with str2
starts = (str1, str2) ->
  return str2 == string.sub str1, 1, string.len str2

{
  :split
  :starts
}

import insert, sort, concat from table
import sub, len from string

-- splits string by newline into array of strings
lines = (str) ->
  tab = {}
  for line in str\gmatch "[^\n]+"
    insert tab, line
  return tab

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

-- bool: does str1 start with str2
starts_with = (str1, str2) ->
  return str2 == sub str1, 1, len str2

-- takes space-separated string and puts it in alphabetical order
--  (handles weird spacing, returns with single-spacing)
alphabetize = (str) ->
  tab = split str
  sort tab
  return concat tab, " "

-- takes space-separated string and removes duplicate entries from it
remove_duplicates = (str) ->
  strings = split str
  tab, result = {}, {}

  for str in *strings
    tab[str] = true
  for str in pairs tab
    insert result, str

  return concat result, " "

{
  :lines
  :split
  :comma_split
  :starts_with
  :alphabetize
  :remove_duplicates

  starts: (...) ->
    -- TODO log deprecated call
    return starts_with(...)
}

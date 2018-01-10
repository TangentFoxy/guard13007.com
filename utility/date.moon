{
  none: "1970-01-01 00:00:00"
  now: -> return os.date "!%Y-%m-%d %X"
  pretty_date: (str) ->
    year, month, day = str\match "(%d%d%d%d)-(%d%d)-(%d%d)"
    return os.date "%B %d, %Y", os.time :year, :month, :day
}

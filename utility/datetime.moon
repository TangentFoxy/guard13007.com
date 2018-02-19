import date, time from os

-- for database
now = ->
  return date "!%Y-%m-%d %X"

-- database date -> display
pretty_date = (str) ->
  year, month, day = str\match "(%d%d%d%d)-(%d%d)-(%d%d)"
  return date "%B %d, %Y", os.time :year, :month, :day

-- from database
to_seconds = (str) ->
  year, month, day, hour, min, sec = str\match "(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d):(%d%d)"
  return time :year, :month, :day, :hour, :min, :sec

-- seconds -> for database
for_db = (seconds) ->
  return date "!%Y-%m-%d %X", seconds

gmt_date = ->
  return date "!*t"

gmt_time = ->
  return time date "!*t"

{
  none: "1970-01-01 00:00:00" -- TODO deprecate
  zero: "1970-01-01 00:00:00" -- for use in database
  :now
  :pretty_date
  :to_seconds
  :for_db
  :gmt_date
  :gmt_time
}

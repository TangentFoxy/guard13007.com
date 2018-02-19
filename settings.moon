import Settings from require "models"

totype = (str) ->
  if value = tonumber str
    return value
  if str == "true"
    return true
  if str == "false"
    return false
  if str == "nil"
    return nil
  return str

cache = {}

local settings
settings = {
  get: (name, skip_index=false) ->
    unless name
      return settings.load!

    unless skip_index -- for metamethods to not loop endlessly
      return settings[name] if settings[name]
    setting = Settings\find :name
    unless setting
      setting = Settings\create :name
    cache[name] = setting
    val = totype setting.value
    settings[name] = val
    return val

  set: (name, value) ->
    unless name
      return settings.save!

    setting = cache[name]
    unless setting
      setting = Settings\find :name
    unless setting
      setting = Settings\create :name
    cache[name] = setting

    if value ~= nil
      settings[name] = value
      return setting\update value: tostring value
    else
      return setting\update value: tostring settings[name]

  save: ->
    for name, value in pairs settings
      unless "function" == type value
        unless cache[name]
          cache[name] = Settings\find :name
        unless cache[name]
          cache[name] = Settings\create :name

    for _, setting in pairs cache
      setting\update value: tostring settings[setting.name]
    return true

  load: ->
    all_settings = Settings\select "WHERE true"
    for setting in *all_settings
      cache[setting.name] = setting
      settings[setting.name] = totype setting.value
    return settings
}

return setmetatable settings, {
    __call: (t, name) ->
      return settings.get name, true
    __index: (t, name) ->
      return settings.get name, true
  }

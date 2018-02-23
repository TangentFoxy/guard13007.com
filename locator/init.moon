config = require "locator_config" -- TODO combine w values from Lapis's config, those overwriting these (this will be a legacy option)

import insert, sort from table

-- require, but only errors when a module errors during loading
check_require = (path) ->
  ok, value = pcall -> require path
  if ok or ("string" == type(value) and 1 == value\find "module '#{path}' not found")
    return ok, value
  else
    error value

-- locates and returns a module
--  if a path is specified, it will be checked before other paths
--  checks the project root, then each path specified in locator_config
locate = (name, path) ->
  print "locate ->"
  if path
    print "  try '#{path}.#{name}'"
    ok, value = check_require "#{path}.#{name}"
    return value if ok

  print "  try '#{name}'"
  ok, value = check_require name
  return value if ok

  for item in *config
    if path
      print "  try '#{item.path}.#{path}.#{name}'"
      ok, value = check_require "#{item.path}.#{path}.#{name}"
    else
      print "  try '#{item.path}.#{name}'"
      ok, value = check_require "#{item.path}.#{name}"
    return value if ok

  if path
    error "locator could not find '#{path}.#{name}'"
  else
    error "locator could not find '#{name}'"

-- works like Lapis's autoload, but
--  includes trying sub-application paths & can be called to access a value
autoload = (path, tab={}) ->
  return setmetatable tab, {
    __call: (t, name) ->
      t[name] = locate name, path
      return t[name]
    __index: (t, name) ->
      t[name] = locate name, path
      return t[name]
  }

-- pass your migrations, it returns them + all sub-application migrations
--  (legacy) see example config for how to specify to not include early migrations
make_migrations = (app_migrations={}) ->
  for item in *config
    ok, migrations = check_require "#{item.path}.migrations"
    if ok
      sorted = {}
      for m in pairs migrations
        insert sorted, m
      sort sorted
      for i in *sorted
        -- only allow migrations after specified config value, or if no 'after' is specified
        if (item.migrations and ((item.migrations.after and i > item.migrations.after) or not item.migrations.after)) or not item.migrations
          -- if your migrations and theirs share a value, combine them
          if app_fn = app_migrations[i]
            app_migrations[i] = (...) ->
              app_fn(...)
              migrations[i](...)
          -- else just add them
          else
            app_migrations[i] = migrations[i]

  return app_migrations

-- sub-applications can define custom functions in a `locator_config` file in
--  their root directory. These functions are aggregated by name and called in
--  the order defined by the paths in the root locator_config (with the root
--  being called first)
registry = setmetatable {}, {
  __index: (t, name) ->
    registered_functions = {}

    if config[name]
      insert registered_functions, config[name]

    for item in *config
      ok, register = check_require "#{item.path}.locator_config"
      if ok and register[name]
        insert registered_functions, register[name]

    if #registered_functions > 0
      t[name] = (...) ->
        for i=1, #registered_functions-1
          registered_functions[i](...)
        return registered_functions[#registered_functions](...)
    else
      t[name] = ->

    return t[name]
}

-- public interface:
--  functions: autoload, make_migrations
--  tables: locate (locator alias), registry
return setmetatable {
  :locate, :autoload, :make_migrations, :registry
}, {
  __call: (t, here="") ->
    if "init" == here\sub -4
      here = here\sub 1, -6
    unless here\len! > 0
      here = ""
    return autoload here

  __index: (t, name) ->
    t[name] = autoload name
    return t[name]
}

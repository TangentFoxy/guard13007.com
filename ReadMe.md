# locator

A <strike>service</strike> module locator for use with Lapis.
(Which doesn't use anythng Lapis-specific, so you could use it elsewhere.)

Installation:

1. subtree this project into the root of your project.
2. `echo 'return require((...) .. ".init")' > locator.lua` (and make sure it is
   committed!)
3. Make `locator_config.moon` using the configuration format specified below.
4. `echo 'return require("locator").models' > models.moon` (to replace the
   models autoloader provided with Lapis with our autoloader)

## Usages

1. `autoload`: A function to allow automatically loading modules when accessing
   a table.
2. Implicit autoloaders: The module itself is an autoloader, and can be called
   to create a specialized autoloader that checks directories local to where
   your code is before other paths.
3. `make_migrations`: A function to make integrating migrations tables from
   multiple Lapis projects into one to streamline applying migrations.

### `autoload` function

The core functionality is based on the `autoload` function, which returns a
table with `__call` and `__index` metamethods, allowing things like:

```
locator = require "locator"

-- the module itself is an autoloader, so you can grab anything in a
-- sub-directory like so:
import Users, Posts from locator.models -- looks in 'models' directory first

-- you can also use it (locator.models) as a function to require from models
Model = locator.models "Model" -- will look for 'models.Model' (& config paths)
```

You can create autoloaders yourself: `models = locator.autoload "models"`

### Implicit autoloaders

In sub-applications, make requiring things easier by acting like everything is
in your repository's root:

```
-- returns an autoloader that will try to require from wherever your
--  sub-application is installed before other paths
locate = require("locator")(...)

util = locate "util" -- will grab *our* utility functions
```

Grab a table of all views: `views = locator.views` (will create an autoloader
  when you try to access it)

### `make_migrations` function

In your migrations, do something like this:

```
import make_migrations from require "locator"
import create_table, types from require "lapis.db.schema"

return make_migrations {
  [1518418142]: =>
    create_table "articles", {
      {"id", types.serial primary_key: true}
      {"title", types.text unique: true}
      {"content", types.text}
    }
}
```

Whatever migrations you have defined will be combined with migrations specified
in sub-applications added to `locator_config`, subject to conditions in the
config file.

## Config

Example configuration:

```
{
  {
    path: "applications.users" -- there is a sub-application at this location
    migrations: {after: 1518414112} -- don't run this migration or any before it
  }
  {
    path: "utility" -- another sub-application is here
  }
}
```

The only required value per item in the configuration is `path`, formatted with
periods as a directory-separator. Currently, the only point of specifying a
migrations table is to specify a migration ID to ignore it and every migration
before it within that sub-application.

Without the configuration file, locator will crash with an error, and without
a path specified, locator doesn't know where else to look for files to require,
so it is very essential.

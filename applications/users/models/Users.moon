import Model from require "lapis.db.model"

import autoload from require "locator"
import settings from autoload "utility"

class Users extends Model
  @timestamp: true

  @constraints: {
    name: (value) =>
      if not value
        return "User names must exist."

      -- TODO make this customizable ?
      if value\find "%W"
        return "User names can only contain alphanumeric characters."

      if Users\find name: value
        return "User names must be unique."

      -- TODO make this extendable? / make this show up BEFORE it gets to erroring at the model
      lower = value\lower!
      if (lower == "admin") or (lower == "administrator") or (lower == "new") or (lower == "edit") or (lower == "create") or (lower == "login") or (lower == "logout") or (lower == "me")
        return "User names must not be 'admin', 'administrator', 'new', 'edit', 'create', 'login', 'logout', or 'me'."

    email: (value) =>
      if settings["users.require-email"]
        unless value
          return "Email addresses must exist."

      -- TODO figure out how to check for valid email address

        if settings["users.require-unique-email"]
          if Users\find email: value
            return "Email addresses must be unique."
  }

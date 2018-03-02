import Model from require "lapis.db.model"
import Users from require "models"

import locate, autoload from require "locator"
import to_seconds, for_db from locate "datetime"
import settings from autoload "utility"
import time from os

class Sessions extends Model
  @create: (values, opts) =>
    now = time!
    values.opened_at = for_db now
    values.closed_at = for_db now + settings["users.session-timeout"]
    return super values, opts

  get: (cookie) =>
    if cookie.session_id
      if session = @find id: cookie.session_id
        now = time!
        if now - to_seconds(session.closed_at) <= 0
          if user = Users\find id: session.user_id
            session\update closed_at: for_db now + settings["users.session-timeout"]
            return user
          else
            session\update closed_at: for_db now
    cookie.session_id = nil

  close: (cookie) =>
    if cookie.session_id
      if session = @find id: cookie.session_id
        session\update closed_at: for_db time!
    cookie.session_id = nil

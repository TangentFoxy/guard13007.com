import Model, enum from require "lapis.db.model"

class Errors extends Model
  @timestamp: true

  @statuses: enum {
    unseen: 1
    open: 2
    closed: 3
    "re-opened": 4
  }

  @constraints: {
    text: (value) =>
      if Errors\find text: value
        error "That error has already been reported."
      unless value
        error "Attempted to log a blank error."
  }

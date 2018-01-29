import Model from require "lapis.db.model"

class States extends Model
  @timestamp: true

  @constraints: {
    type: (value) =>
      if States\find type: value
        error "A '#{value}' state already exists."
      unless value
        error "Attempted to create an untyped state."
  }

import Model, enum from require "lapis.db.model"

class GameKeys extends Model
  @timestamp: true

  @types: enum {
    steam: 1
    humblebundle: 2
    origin: 3
    uplay: 4
    other: 5
  }

  @statuses: enum {
    unclaimed: 1
    claimed: 2
  }

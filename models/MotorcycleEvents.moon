import Model, enum from require "lapis.db.model"

class MotorcycleEvents extends Model
  @primary_key: "user_id"

  @events: enum {
    gas: 1
    oil_change: 2
    insurance: 3
    registration: 4
    front_tire: 5
    rear_tire: 6
    battery: 7
  }

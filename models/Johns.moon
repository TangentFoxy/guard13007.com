import Model from require "lapis.db.model"

class Johns extends Model
    @timestamp: true

    @constraints: {
        john: (value) =>
            if not value or value\len! < 1
                return "Must have a John."
    }

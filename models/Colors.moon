import Model, enum from require "lapis.db.model"

class Colors extends Model
    @constraints: {
        code: (value) =>
            unless value\len! == 3 or value\len! == 6
                return "Invalid hex code. (Must be 3 or 6 characters long.)"
    }

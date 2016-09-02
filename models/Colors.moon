import Model, enum from require "lapis.db.model"

class Colors extends Model
    @constraints: {
        code: (value) =>
            unless code\len! == 3 or code\len! == 6
                return "Invalid hex code. (Must be 3 or 6 characters long.)"
    }

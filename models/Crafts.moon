import Model, enum from require "lapis.db.model"

import trim from require "lapis.util"

class Crafts extends Model
    @timestamp: true

    @statuses: enum {
        new: 0
        pending: 1
        reviewed: 2
        rejected: 3
        delayed: 4
        priority: 5
        old: 6
        imported: 7
    }

    @constraints: {
        craft_name: (value) =>
            if not value or value\len! < 1
                return "Craft must have a name!"

        download_link: (value) =>
            if not value or value\len! < 1
                return "You must enter a link to the craft!"
            if Crafts\find download_link: value
                return "That craft has already been submitted!"
        creator_name: (value) =>
            value = trim value
            return

            --TODO validate URL here!
            --     (uhh, accidentally was validating it elsewhere...)

        --description: (value) =>
        --    unless value
        --        return "You must enter a description of the craft!"
        --creator_name: (value) =>
        --    unless value
        --        return "You must enter a name for the crafts' creator."
        --ksp_version: (value) =>
        --    unless value
        --        return "You must tell me what version of KSP this craft was made in."
    }

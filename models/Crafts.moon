import Model, enum from require "lapis.db.model"

import Tags from require "models"
import trim from require "lapis.util"
import locate from require "locator"
import starts from locate "gstring"

http = require "lapis.nginx.http"

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

  get_previous: =>
    return Crafts\select("WHERE id < ? ORDER BY id DESC LIMIT 1", @id)[1]
  get_next: =>
    return Crafts\select("WHERE id > ? ORDER BY id LIMIT 1", @id)[1]

  delete: (...) =>
    Tags\remove(@)
    super(...)

  @constraints: {
    name: (value) =>
      if not value or value\len! < 1
        return "Craft must have a name!"

    download_link: (value) =>
      if not value or value\len! < 1
        return "You must enter a link to the craft!"
      if Crafts\find download_link: value
        return "That craft has already been submitted!"

      _, http_status = http.simple value
      if http_status == 404 or http_status == 403 or http_status == 500
        return "Craft link is invalid."

    picture: (value) =>
      if not value or value\len! < 1
        error "An image URL must be defined."

      if "https://" == value\sub 1, 8
        return "You must use a secure link (starting with https://)."

      if starts(value, "https://dropbox.com") or starts(value, "https://www.dropbox.com")
        return "Dropbox cannot be used to host images."
      if starts(value, "https://youtube.com") or starts(value, "https://www.youtube.com")
        return "YouTube cannot be used to host images.."
      if starts(value, "https://imgur.com/a/") or starts(value, "https://imgur.com/gallery/")
        return "Use the direct link to an image on Imgur, not an album or gallery."
      if starts(value, "https://images.akamai.steamusercontent.com")
        return "Steam's user images are not securely served, so I do not accept them."

      _, http_status = http.simple value
      if http_status == 404 or http_status == 403 or http_status == 500 or http_status == 301 or http_status == 302
        return "Image URL is invalid."
  }

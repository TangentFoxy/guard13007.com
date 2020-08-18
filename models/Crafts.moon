import Model, enum from require "lapis.db.model"

import Tags from require "models"
import trim from require "lapis.util"
import starts_with from require "utility.gstring"

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

  @relations: {
    { "user", belongs_to: "Users" }
    { "craft_tags", has_many: "CraftTags" }
  }

  get_previous: =>
    return Crafts\select("WHERE id < ? ORDER BY id DESC LIMIT 1", @id)[1]
  get_next: =>
    return Crafts\select("WHERE id > ? ORDER BY id LIMIT 1", @id)[1]

  delete: (...) =>
    Tags\remove_item(@)
    super(...)

  @constraints: {
    name: (value) =>
      if not value or value\len! < 1
        return "Craft must have a name!"

    download_link: (value) =>
      if not value or value\len! < 1
        return "You must enter a link to download the craft!"
      if Crafts\find download_link: value
        return "A craft with that download link has already been submitted!"

      _, http_status = http.simple value
      if http_status == 404 or http_status == 403 or http_status == 500
        return "Craft link is invalid. (Returned a #{http_status} error code.)"

    picture: (value) =>
      if not value or value\len! < 1
        error "Internal error: An image URL must be defined. Please contact the site administrator."

      unless "https://" == value\sub 1, 8
        return "You must use a full link over HTTPS (aka: a link starting with https://)."

      if starts_with(value, "https://dropbox.com") or starts_with(value, "https://www.dropbox.com")
        return "Dropbox cannot be used to host images as they block embedding."
      if starts_with(value, "https://youtube.com") or starts_with(value, "https://www.youtube.com")
        return "YouTube cannot be used to host images."
      if starts_with(value, "https://imgur.com/a/") or starts_with(value, "https://imgur.com/gallery/")
        return "Use the direct link to an image on Imgur, not an album or gallery."
      if starts_with(value, "https://images.akamai.steamusercontent.com")
        return "Steam's user images are not securely served over HTTPS, so they cannot be used."

      _, http_status = http.simple value
      if http_status == 404 or http_status == 403 or http_status == 500 or http_status == 301 or http_status == 302
        return "Image URL is invalid. (Returned a #{http_status} error code.)"
  }

import Model, enum from require "lapis.db.model"

import starts from require "utility.string"
import trim from require "lapis.util"

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
      if value\len! > 0
        if value\sub(1, 7) == "http://"
          value = "https://#{value\sub 8}"
        elseif value\sub(1, 8) != "https://"
          value = "https://#{value}"
        t = value
        if starts(value, "https://dropbox.com") or starts(value, "https://www.dropbox.com")
          return "Dropbox cannot be used to host images."
        if starts(value, "https://youtube.com") or starts(value, "https://www.youtube.com")
          return "YouTube cannot be used to host images.."
        if starts(value, "https://imgur.com/a/") or starts(value, "https://imgur.com/gallery/")
          return "Use the direct link to an image on Imgur, not an album."
        if starts(value, "https://images.akamai.steamusercontent.com")
          return "Steam's user images are not securely served, so I cannot accept them."
        --if starts(value, "https://imgur.com/")
          -- TODO fix with a PNG, JPG, or GIF extension and i.imgur.com
        _, http_status = http.simple value
        if http_status == 404 or http_status == 403 or http_status == 500 or http_status == 301 or http_status == 302
          return "Image URL is invalid."

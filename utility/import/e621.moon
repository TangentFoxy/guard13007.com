http = require "lapis.nginx.http"

import E621Images, E621Tags, E621ImageTags, E621LockedImageTags, E621ImageChildren, E621Artists, E621ImageArtists, E621Sources, E621ImageSources from require "models"
import decode, fix_null from require "utility.import.common"
import split, comma_split from require "utility.string"
import insert from table

request = (url) ->
  return decode http.simple {
    :url
    headers: {
      "User-Agent": "fursimile/1.0 (by Huiojin2 on e621)"
    }
  }

add_tags = (image_id, tags) ->
  tags = "unknown_artist needs_tags tag_me" unless tags
  tags = split tags
  for name in *tags
    tag, err = E621Tags\find(:name) or E621Tags\create(:name)
    unless tag return err
    association, err = E621ImageTags\create :image_id, tag_id: tag.id
    unless association return err

add_locked_tags = (image_id, tags) ->
  if tags
    tags = split tags
    for name in *tags
      tag, err = E621Tags\find(:name) or E621Tags\create(:name)
      unless tag return err
      association, err = E621LockedImageTags\create :image_id, tag_id: tag.id
      return err if err

add_children = (image_id, children) ->
  if children
    children = comma_split children
    for child in *children
      association, err = E621ImageChildren\create :image_id, child_id: tonumber child
      unless association return err

add_artists = (image_id, artists) ->
  -- TODO verify that the way these are stored is okay
  if artists
    for name in *artists
      artist, err = E621Artists\find(:name) or E621Artists\create(:name)
      unless artist return err
      association, err = E621ImageArtists\create :image_id, artist_id: artist.id
      unless association return err

add_sources = (image_id, sources) ->
  if sources
    for value in *sources
      source, err = E621Sources\find(:value) or E621Sources\create(:value)
      unless source return err
      association, err = E621ImageSources\create :image_id, source_id: source.id
      unless association return err

create = (data) ->
  if E621Images\find id: data.id
    return nil -- do not return existing images!

  -- id is fine
  tags = fix_null data.tags
  data.tags = nil
  locked_tags = fix_null data.locked_tags
  data.locked_tags = nil
  -- description is fine
  data.created_at_s = data.created_at.s
  data.created_at_n = data.created_at.n
  data.created_at = nil
  data.creator_id = fix_null data.creator_id -- assumed possibility
  data.author = fix_null data.author         -- assumed possibility
  -- change is fine
  data.source = nil
  -- score is fine
  -- fav_count is fine
  data.md5 = fix_null data.md5
  -- md5 should be unique (model checks this)
  data.file_size = fix_null data.file_size
  -- file_url may be duplicated
  data.file_ext = fix_null data.file_ext
  -- preview_url may be duplicated
  data.preview_width = fix_null data.preview_width
  data.preview_height = fix_null data.preview_height
  data.sample_url = fix_null data.sample_url
  data.sample_width = fix_null data.sample_width
  data.sample_height = fix_null data.sample_height
  data.rating = E621Images.ratings\for_db data.rating
  data.status = E621Images.statuses\for_db data.status
  -- width is fine
  -- height is fine
  -- has_comments is fine
  -- has_notes is fine
  data.has_children = fix_null data.has_children
  children = fix_null data.children
  data.children = nil
  data.parent_id = fix_null data.parent_id
  artists = fix_null data.artist
  data.artist = nil
  sources = fix_null data.sources
  data.sources = nil
  data.delreason = fix_null data.delreason

  image, err = E621Images\create data

  errors_str = err or ""
  if image
    if err = add_tags image.id, tags
      errors_str ..= "\n#{err}"
    if err = add_locked_tags image.id, locked_tags
      errors_str ..= "\n#{err}"
    if err = add_children image.id, children
      errors_str ..= "\n#{err}"
    if err = add_artists image.id, artists
      errors_str ..= "\n#{err}"
    if err = add_sources image.id, sources
      errors_str ..= "\n#{err}"
    if errors_str\len! > 0
      image, err = image\update dirty: true
      if err
        errors_str ..= "\n#{err}"

  if errors_str\len! > 0
    return image, errors_str
  else
    return image

-- returns an E621Images object, with possibly a string of error messages,
-- or just a NIL
get_image = (id) ->
  return create request "https://e621.net/post/show.json?id=#{id}"

-- returns a table of E621Images objects and a table of error messages (strings)
-- both of these tables may be empty, or of varying length
get_images = (id, limit=320) ->
  if id
    data = request "https://e621.net/post/index.json?limit=#{limit}&before_id=#{id}"
  else
    data = request "https://e621.net/post/index.json"

  images, errors = {}, {}
  for image_data in *data
    image, errors_str = create image_data
    insert images, image if image
    insert errors, errors_str if errors_str

  return images, errors

{
  :get_image
  :get_images
}

lapis = require "lapis"

import States, Errors, E621Images from require "models"
import encode, decode from require "cjson"
import e621 from require "utility.import"
import append from require "utility.table"
import execute from require "utility.shell"
import insert, remove from table
import time from os

wait = (s=1) ->
  ngx.sleep s

log = (errors) ->
  for err in *errors
    if error_log = Errors\find text: err
      error_log.count += 1
      if error_log.status == Errors.statuses.closed
        error_log.status = Errors.statuses['re-opened']
        error_log\update "count", "status"
      else
        error_log\update "count"
    else
      error_log = Errors\create text: err
      -- don't bother checking for errors...if they occur here we're fucked anyhow

class extends lapis.Application
  @path: "/cron"
  @name: "cron_"

  [e621: "/e621"]: =>
    -- allowed to run for 4.5 minutes, should be called every 5 minutes
    timeout = 4.5 * 60
    start = time!

    -- to make things hit the database a little softer / a little more efficient
    -- we store E621Images objects (keyed by image ID)
    cached_images = {}
    store_id_and_cache = (images) ->
      image_ids = {}
      for image in *images
        cached_images[image.id] = image
        insert image_ids, image.id
      return image_ids

    state = States\find type: "e621"
    unless state
      images, errors = e621.get_images!
      log errors
      if images[1]
        state = States\create {
          type: "e621"
          value: encode {
            new_id: images[1].id + 100 -- check 100 IDs in the future from the latest
            old_id: images[#images].id -- check maximum number of IDs below what we last grabbed
            current_process: "downloading_new"
            data: store_id_and_cache images
          }
        }
      else
        error errors[1]
      wait!

    -- now to decode the state and do something about it!
    -- I'm thinking decode, then go into a while loop with a switch in it depending on sub-states
    -- in this while loop, every time we change what we're doing, update the loaded state data,
    --  so any time we're forced out, we're in a clean state to save
    raw_state = decode state.value
    while time! < start + timeout
      switch raw_state.current_process
        when "scraping_new"
          images, errors = e621.get_images raw_state.new_id, 100
          log errors
          if images[1]
            raw_state.current_process = "downloading_new"
            raw_state.data = append raw_state.data, store_id_and_cache images
            if images[1].id > raw_state.new_id
              raw_state.new_id = images[1].id + 100 -- check 100 IDs in the future from the latest
        when "scraping_old"
          images, errors = e621.get_images raw_state.old_id
          log errors
          if images[1]
            raw_state.current_process = "downloading_old"
            raw_state.data = append raw_state.data, store_id_and_cache images
            raw_state.old_id = images[#images].id -- check maximum number of IDs below what we last grabbed

        else -- both downloading_new and downloading_old
          if id = remove raw_state.data
            image = cached_images[id] or E621Images\find :id
            if image.md5
              errors = {}
              exec_capture_error = (cmd) ->
                output, exit_code = execute cmd
                if exit_code != 0
                  insert errors, "Execution exited with '#{exit_code}': #{cmd}\n\n#{output}"

              path = "./static/images/#{image.md5\sub 1, 2}/#{image.md5\sub 3, 4}"
              exec_capture_error "mkdir -p #{path}"
              exec_capture_error "wget -nc #{image.file_url} -O #{path}/#{image.md5}.#{image.file_ext}"
              wait!

              path ..= "/preview"
              exec_capture_error "mkdir -p #{path}"
              exec_capture_error "wget -nc #{image.preview_url} -O #{path}/#{image.md5}.#{image.file_ext}"
              wait!

              path = "#{path\sub 1, -9}/sample"
              exec_capture_error "mkdir -p #{path}"
              exec_capture_error "wget -nc #{image.sample_url} -O #{path}/#{image.md5}.#{image.file_ext}"
              -- wait! -- no final wait because it is handled after the switch

              log errors
          else
            if raw_state.current_process == "downloading_new"
              raw_state.current_process = "scraping_old"
            else
              raw_state.current_process = "scraping_new"

      -- no matter which branch of the switch, do one final wait
      -- (only 'downloading' state has additional wait calls)
      wait!

    -- save state
    state, err = state\update value: encode raw_state
    log {err} if err

    return status: 200, "e621 scrape completed"

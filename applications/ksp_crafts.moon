lapis = require "lapis"
http = require "lapis.nginx.http"
db = require "lapis.db"

import Crafts, Tags, Users from require "models"
import respond_to, capture_errors, assert_error, yield_error from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"
import locate from require "locator"
import split from locate "gstring"
import invert from locate "gtable"
-- import random from require "calc"
import random from math -- tmp
import ceil from math

validate_functions.not_equals = (...) ->
  return not validate_functions.equals(...)

fix_url = (url="") ->
  if "http://" == url\sub 1, 7
    url = "https://#{url\sub 8}"
  elseif "https://" != url\sub 1, 8
    url = "https://#{url}"
  -- this can break some sites, so I won't do it just in case...
  -- if "www." == url\sub 9, 12
  --   url = "https://#{url\sub 13}"

  _, http_status = http.simple url
  if http_status == 404 or http_status == 403 or http_status == 500 or http_status == 301 or http_status == 302
    yield_error "Image URL is invalid."
  else
    return url

class KSPCraftsApp extends lapis.Application
  @path: "/gaming/ksp"
  @name: "ksp_crafts_"

  -- TODO this will be defined on a different app or as a page
  -- [index: ""]: => return redirect_to: @url_for "ksp_crafts_index"

  [tags: "/craft-tags(/:page[%d])"]: =>
    @page = tonumber(@params.page) or 1

    per_page = 4*13
    @last_page = ceil db.query("SELECT COUNT(DISTINCT tag_id) FROM craft_tags")[1].count / per_page
    @tags = db.query "SELECT tags.*, COUNT(tag_id) AS count FROM tags INNER JOIN craft_tags ON tags.id = craft_tags.tag_id GROUP BY tags.id ORDER BY count DESC, name ASC LIMIT #{per_page} OFFSET #{db.escape_literal per_page * (@page - 1)}"

    if #@tags < 1 and @last_page > 0
      return redirect_to: @url_for "ksp_crafts_tags", page: @last_page

    @title = "Submitted Craft - Tags"
    return render: "ksp.crafts_tags"

  [index: "/crafts(/:tab)(/:page[%d])"]: =>
    if a = tonumber @params.tab
      @params.tab = nil
      @params.page = a
    @page = tonumber(@params.page) or 1

    local Paginator
    if @params.tab == "all" or @params.tab == nil
      Paginator = Crafts\paginated "ORDER BY id ASC", per_page: 19
    elseif @params.tab == "pending"
      Paginator = Crafts\paginated "WHERE status IN (?, ?, ?, ?, ?) ORDER BY id ASC", Crafts.statuses.priority, Crafts.statuses.imported, Crafts.statuses.pending, Crafts.statuses.delayed, Crafts.statuses.old, per_page: 19
    elseif Crafts.statuses[@params.tab]
      Paginator = Crafts\paginated "WHERE status = ? ORDER BY id ASC", Crafts.statuses[@params.tab], per_page: 19
    else
      if tag = Tags\find name: @params.tab
        Paginator = Crafts\paginated "WHERE id IN (SELECT craft_id FROM craft_tags WHERE tag_id = ?) ORDER BY id ASC", tag.id, per_page: 19
      else
        Paginator = Crafts\paginated "WHERE false"

    @last_page = Paginator\num_pages!
    @crafts = Paginator\get_page @page
    if #@crafts < 1 and @last_page > 0
      return redirect_to: @url_for "ksp_crafts_index", tab: @params.tab, page: @last_page

    @title = "Submitted Craft"
    @page_arguments = tab: @params.tab
    return render: "ksp.crafts_index"

  [view: "/craft/:id[%d]"]: respond_to {
    GET: =>
      if @craft = Crafts\find id: @params.id
        name = @craft.creator
        the_date = os.date "*t", os.time!
        if the_date.month == 4 and the_date.day == 1
          name = "John"
        elseif @craft.user_id != 0
          if user = Users\find id: @craft.user_id
            name = user.name
        if name\len! > 0
          @title = "#{@craft.name} by #{name}"
        else
          @title = @craft.name
        return render: "ksp.crafts_view"

      else
        @session.info = "That craft does not exist."
        return redirect_to: @url_for "ksp_crafts_index"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for("ksp_crafts_view", id: @params.id)

      =>
        unless @user
          yield_error "You are not logged in."
        craft = assert_error Crafts\find id: @params.id
        unless @user.admin or @user.id == craft.user_id
          yield_error "You do not have permission to edit this craft."
        fields = {}
        for name, data in pairs @params
          switch name
            when "id", "tags"
              nil -- ignore
            when "status", "episode", "notes", "creator", "user_id", "delete"
              unless @user.admin
                yield_error "You must be an administrator to edit a craft's #{name}."
              switch name
                when "status", "user_id"
                  data = tonumber data
                  if craft[name] != data
                    fields[name] = data
                when "delete"
                  assert_error craft\delete!
                  @session.info = "Craft deleted."
                  return redirect_to: @url_for "ksp_crafts_index"
                else
                  if data and data\len! > 0 and data != craft[name]
                    fields[name] = data
            else
              if data and data\len! > 0 and data != craft[name]
                fields[name] = data
        if @params.tags
          if Tags\set craft, @params.tags -- uses assert_error internally, returns bool indicating if updates actually occurred
            @session.info = "Craft tags updated."
        if next fields
          assert_error craft\update fields
          if @session.info
            @session.info ..= "\nCraft updated."
          else
            @session.info = "Craft updated."
        return redirect_to: @url_for "ksp_crafts_view", id: @params.id
    }
  }

  [submit: "/submit"]: respond_to {
    GET: =>
      @title = "Submit a craft to be reviewed!"
      return render: "ksp.crafts_submit"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for "ksp_crafts_submit"

      =>
        status = Crafts.statuses.new
        user_id = 0
        if @user
          if @user.admin
            status = Crafts.statuses.imported
          else
            @params.creator = @user.name
            user_id = @user.id

        if not @params.picture or @params.picture\len! < 1
          @params.picture = "https://guard13007.com/static/img/ksp/no_image.png"

        @params.download_link = fix_url @params.download_link
        @params.picture = fix_url @params.picture

        assert_error Crafts\create {
          name: @params.name
          download_link: @params.download_link
          creator: @params.creator
          description: @params.description
          action_groups: @params.action_groups
          ksp_version: @params.ksp_version
          mods_used: @params.mods_used
          picture: @params.picture
          user_id: user_id
          status: status
        }

        return redirect_to: @url_for "ksp_crafts_view", id: craft.id
    }
  }

  [search: "/search"]: =>
    if @params.name and @params.name\len! > 0 -- legacy..again
      @params.query = @params.name

    if @params.query and @params.query\len! > 0
      if @params.version and @params.version\len! > 0
        @title = "KSP Crafts Search: #{@params.query} v#{@params.version}"
        @crafts = Crafts\select "WHERE (name ILIKE ? OR creator ILIKE ? OR description ILIKE ?) AND ksp_version ILIKE ? ORDER BY id ASC", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.version.."%"
      else
        @title = "KSP Crafts Search: #{@params.query}"
        @crafts = Crafts\select "WHERE name ILIKE ? OR creator ILIKE ? OR description ILIKE ? ORDER BY id ASC", "%"..@params.query.."%", "%"..@params.query.."%", "%"..@params.query.."%"
    else
      @title = "KSP Crafts Search"

    return render: "ksp.crafts_search"

  [random: "/random"]: =>
    local crafts
    if @user and @user.admin
      -- NOT reviewed, rejected, or delayed
      crafts = Crafts\select "WHERE status NOT IN (?, ?, ?)", Crafts.statuses.reviewed, Crafts.statuses.rejected, Crafts.statuses.delayed
    else
      crafts = Crafts\select "WHERE true"

    if #crafts > 0
      return redirect_to: @url_for "ksp_crafts_view", id: crafts[random 1, #crafts].id
    elseif @user and @user.admin
      return redirect_to: @url_for "ksp_crafts_index", tab: "pending" -- to show there are none except delayed craft
    else
      return redirect_to: @url_for "ksp_crafts_index", tab: "all"     -- to show there are none D:

  "/craft": => return redirect_to: @url_for "ksp_crafts_index"

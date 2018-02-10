lapis = require "lapis"
db = require "lapis.db"

import Crafts, Tags, CraftTags, Users from require "models"
import respond_to from require "lapis.application"
import split from require "utility.string"
import invert from require "utility.table"

class KSPCraftsApp extends lapis.Application
  @path: "/gaming/ksp"
  @name: "ksp_crafts_"

  -- TODO this will be defined on a different app or as a page
  -- [index: ""]: => return redirect_to: @url_for "ksp_crafts_index"

  [tags: "/tags(/:page[%d])"]: =>
    @page = tonumber(@params.page) or 1

    @last_page = db.query("SELECT COUNT(DISTINCT tag_id) FROM craft_tags")[1].count
    @tags = db.query "SELECT tags.*, COUNT(tag_id) AS count FROM tags INNER JOIN craft_tags ON tags.id = craft_tags.tag_id GROUP BY tags.id ORDER BY count DESC, name ASC LIMIT 50 OFFSET #{db.escape_literal 50 * @page - 1}"

    if #@tags < 1 and @last_page > 0
      return redirect_to: @url_for "ksp_crafts_tags", page: @last_page

    @title = "Craft Tags"
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

    POST: =>
      if @session.id
        if user = Users\find id: @session.id
          if craft = Crafts\find id: @params.id
            fields = {}

            if user.id == craft.user_id or user.admin
              -- name, description, download_link, picture, action_groups, ksp_version, mods_used
              if @params.craft_name and @params.name\len! > 0 and @params.name != craft.name
                fields.name = @params.name
              if @params.description and @params.description\len! > 0 and @params.description != craft.description
                fields.description = @params.description
              if @params.download_link and @params.download_link\len! > 0 and @params.download_link != craft.download_link
                fields.download_link = @params.download_link
              if @params.picture and @params.picture\len! > 0 and @params.picture != craft.picture
                fields.picture = @params.picture
              if @params.action_groups and @params.action_groups\len! > 0 and @params.action_groups != craft.action_groups
                fields.action_groups = @params.action_groups
              if @params.ksp_version and @params.ksp_version\len! > 0 and @params.ksp_version != craft.ksp_version
                fields.ksp_version = @params.ksp_version
              if @params.mods_used and @params.mods_used\len! > 0 and @params.mods_used != craft.mods_used
                fields.mods_used = @params.mods_used

              if user.admin
                -- status, episode, notes, creator, user_id
                if @params.status and @params.status\len! > 0 and @params.status != craft.status
                  fields.status = Crafts.statuses\for_db tonumber @params.status
                if @params.episode and @params.episode\len! > 0 and @params.episode != craft.episode
                  fields.episode = @params.episode
                if @params.notes and @params.notes\len! > 0 and @params.notes != craft.notes
                  fields.notes = @params.notes
                if @params.creator and @params.creator\len! > 0 and @params.creator != craft.creator
                  fields.creator = @params.creator
                if @params.user_id and @params.user_id\len! > 0 and @params.user_id != craft.user_id
                  fields.user_id = tonumber @params.user_id

                -- handle tags
                if @params.tags
                  oldTags = CraftTags\hash craft_id: craft.id
                  newTags = invert split @params.tags
                  addedTags, removedTags = {}, {}
                  for tag in pairs newTags
                    unless oldTags[tag]
                      addedTags[tag] = true
                  for tag in pairs oldTags
                    unless newTags[tag]
                      removedTags[tag] = true
                  for name in pairs addedTags
                    tag = Tags\find(:name) or Tags\create(:name)
                    CraftTags\create tag_id: tag.id, craft_id: craft.id
                  for name in pairs removedTags
                    craftTag = CraftTags\find craft_id: craft.id, tag_id: (Tags\find(:name)).id
                    craftTag\delete!
                  -- lack of error checking :/

                if @params.delete
                  if craft\delete!
                    @session.info = "Craft deleted."
                    return redirect_to: @url_for "ksp_crafts_index"
                  else
                    @session.info = "Error deleting craft!"
                    return redirect_to: @url_for "ksp_crafts_view", id: @params.id

            if next fields
              craft\update fields
              @session.info = "Craft updated."
              return redirect_to: @url_for "ksp_crafts_view", id: @params.id
          else
            @session.info = "That craft does not exist."
            return redirect_to: @url_for "ksp_crafts_index"

      @session.id = nil
      @session.info = "You are not logged in."
      return redirect_to: @url_for "ksp_crafts_view", id: @params.id
  }

  [submit: "/submit"]: respond_to {
    GET: =>
      @title = "Submit a craft to be reviewed!"
      return render: "ksp.crafts_submit"
    POST: =>
      status = Crafts.statuses.new
      user_id = 0
      if @session.id
        if user = Users\find id: @session.id
          if user.admin
            status = Crafts.statuses.imported
          else
            @params.creator = user.name
            user_id = user.id

      if not @params.picture or @params.picture\len! < 1
        @params.picture = "/static/img/ksp/no_image.png"

      craft, err = Crafts\create {
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

      if craft
        return redirect_to: @url_for "ksp_crafts_view", id: craft.id
      else
        @info = "Craft submission failed: #{err}"
        return render: "ksp.crafts_submit"
  }

  [search: "/search"]: =>
    if @params.query and @params.query\len! > 0 -- legacy
      @params.name = @params.query

    if @params.name and @params.name\len! > 0
      if @params.version and @params.version\len! > 0
        @title = "KSP Crafts Search: #{@params.name} v#{@params.version}"
        @crafts = Crafts\select "WHERE (name LIKE ? OR creator LIKE ? OR description LIKE ?) AND ksp_version LIKE ? ORDER BY id ASC", "%"..@params.name.."%", "%"..@params.name.."%", "%"..@params.name.."%", "%"..@params.version.."%"
      else
        @title = "KSP Crafts Search: #{@params.name}"
        @crafts = Crafts\select "WHERE name LIKE ? OR creator LIKE ? OR description LIKE ? ORDER BY id ASC", "%"..@params.name.."%", "%"..@params.name.."%", "%"..@params.name.."%"
    else
      @title = "KSP Crafts Search"

    return render: "ksp.crafts_search"

  "/craft": => return redirect_to: @url_for "ksp_crafts_index"

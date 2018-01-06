lapis = require "lapis"

import Crafts, Users from require "models"
import respond_to from require "lapis.application"

class KSPCraftsApp extends lapis.Application
  @path: "/gaming/ksp"
  @name: "ksp_crafts_"

  -- TODO this will be defined on a different app or as a page
  -- [index: ""]: => return redirect_to: @url_for "ksp_crafts_list"

  [index: "/crafts(/:tab[a-z])(/:page[%d])"]: =>
    @page = tonumber(@params.page) or 1

    local Paginator
    if @params.tab == "all" or @params.tab == nil
      Paginator = Crafts\paginated "ORDER BY id ASC", per_page: 19
    elseif @params.tab == "pending"
      Paginator = Crafts\paginated "WHERE status IN (?, ?, ?, ?, ?) ORDER BY id ASC", "priority", "imported", "pending", "delayed", "old", per_page: 19
    elseif not Crafts.statuses[@params.tab]
      return redirect_to: @url_for "ksp_crafts_index"
    else
      Paginator = Crafts\paginated "WHERE status = ? ORDER BY id ASC", @params.tab, per_page: 19

    @last_page = Paginator\num_pages!
    @crafts = Paginator\get_page @page
    if #@crafts < 1 and @last_page > 0
      return redirect_to: @url_for "ksp_crafts_index", tab: @params.tab, page: @last_page

    @title = "Submitted Craft"
    return render: "ksp.crafts_index"

  [view: "/craft/:id[%d]"]: =>
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

  "/craft": => return redirect_to: @url_for "ksp_crafts_list"

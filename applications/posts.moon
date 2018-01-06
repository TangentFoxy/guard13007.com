lapis = require "lapis"

import Posts from require "models"
import respond_to from require "lapis.application"
import slugify from require "lapis.util"
import is_admin from require "utility.auth"

gdate = require "utility.date"

class extends lapis.Application
  @path: "/post"
  @name: "posts_"

  [index: "s(/:page[%d])"]: =>
    @page = tonumber(@params.page) or 1
    Paginator = Posts\paginated "WHERE status = ? ORDER BY published_at DESC", Posts.statuses.published, per_page: 6

    @last_page = Paginator\num_pages!
    @posts = Paginator\get_page @page
    if #@posts < 1 and @last_page > 0
      return redirect_to: @url_for "posts_index", page: @last_page

    @title = "All Posts (Page #{@page})"
    @previous_label = "Most recent"
    @next_label = "Oldest"
    return render: "posts.index"

  [view: "/:slug"]: =>
    @post = Posts\find slug: @params.slug
    if (not @post) or (@post.status != Posts.statuses.published and not is_admin @)
      @session.info = "That post does not exist."
      return redirect_to: @url_for "posts_index"
    else
      @title = @post.title
      return render: "posts.view"

  [admin_index: "s/admin/index(/:page[%d])"]: =>
    unless is_admin @ return redirect_to: @url_for "posts_index"

    @page = tonumber(@params.page) or 1
    Paginator = Posts\paginated "ORDER BY updated_at DESC", per_page: 50

    @last_page = Paginator\num_pages!
    @posts = Paginator\get_page @page
    if #@posts < 1 and @last_page > 0
      return redirect_to: @url_for "posts_admin_index", page: @last_page

    @title = "Admin Posts Index (Page #{@page})"
    return render: "posts.admin_index"

  [new: "/new"]: respond_to {
    before: =>
      unless is_admin @ return redirect_to: @url_for "posts_index"
    GET: =>
      @title = "New Post"
      return render: "posts.edit"
    POST: =>
      fields = {
        title: @params.title
        slug: slugify @params.title
        text: @params.text
        -- preview_text set below
        html: @params.html
        preview_html: @params.preview_html
        status: tonumber @params.status
        type: tonumber @params.type
      }

      if @params.slug and @params.slug\len! > 0
        fields.slug = @params.slug

      if @params.preview_text and @params.preview_text\len! > 0
        fields.preview_text = @params.preview_text
      else
        fields.preview_text = @params.text\sub 1, 500

      if fields.status == Posts.statuses.published
        fields.published_at = gdate.now!
      elseif fields.status == Posts.statuses.scheduled and @params.published_at and @params.published_at\len! > 0
        fields.published_at = @params.published_at
      else
        fields.status = Posts.statuses.draft
        fields.published_at = gdate.none

      if @params.splat and @params.splat\len! > 0
        fields.splat = @params.splat

      post, err = Posts\create fields
      if post
          @session.info = "Post created!"
          if post.status != Posts.statuses.draft
            return redirect_to: @url_for "posts_view", slug: post.slug
          else
            return redirect_to: @url_for "posts_edit", id: post.id
      else
        @session.info = "Failed to create post. #{err}"
        return redirect_to: @url_for "posts_new"
  }

  [edit: "/edit/:id[%d]"]: respond_to {
    before: =>
      unless is_admin @ return redirect_to: @url_for "posts_index"
      @post = Posts\find id: @params.id
      unless @post
        @session.info = "That post does not exist."
        return redirect_to: @url_for "posts_index"
    GET: =>
      @title = "#{@post.title} (Editing)"
      return render: "posts.edit"
    POST: =>
      fields = {
        -- title will error if you set it to its existing value
        -- slug is only modified if user modified it
        text: @params.text
        -- preview_text may not be set (if is default / generated)
        html: @params.html
        preview_html: @params.preview_html
        status: tonumber @params.status
        type: tonumber @params.type
      }

      if @params.title and @params.title\len! > 0 and @params.title != @post.title
        fields.title = @params.title

      if @params.slug and @params.slug\len! > 0 and @params.slug != @post.slug
        fields.slug = @params.slug

      if @params.preview_text and @params.preview_text\len! > 0
        fields.preview_text = @params.preview_text

      if @params.splat and @params.splat\len! > 0
        fields.splat = @params.splat

      -- draft -> scheduled?
      if @post.status == Posts.statuses.draft and fields.status == Posts.statuses.scheduled and @params.published_at and @params.published_at\len! > 0
        fields.published_at = @params.published_at
      -- draft -> published / scheduled -> published
      if fields.status == Posts.statuses.published and not @post.status == Posts.statuses.published
        fields.published_at = gdate.now!

      _, err = @post\update fields
      unless err
        @info = "Post updated. #{fields.published_at}"
      else
        @info = "Failed to update post. #{err}"

      @title = "#{@post.title} (Editing)"
      return render: "posts.edit"
  }

  [delete: "/delete/:id[%d]"]: =>
    unless is_admin @ return redirect_to: @url_for "posts_index"

    if post = Posts\find id: @params.id
      if post\delete!
        @session.info = "Post deleted."
      else
        @session.info = "Error while deleting post!"
        return redirect_to: @url_for "posts_edit", id: @params.id
    else
      @session.info = "A post with ID #{@params.id} does not exist. (Perhaps it was already deleted?)"

    return redirect_to: @url_for "posts_admin_index"

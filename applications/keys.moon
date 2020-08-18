lapis = require "lapis"

import respond_to, capture_errors, assert_error from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"

import Keys from require "models"

key_validations = {
  { "item", exists: true, "You must enter what this key is for." }
  { "key", exists: true, "You must enter a key, URL, or instructions for redeeming this key." }
  { "type", exists: true, "You must select a key type." }
}

class extends lapis.Application
  @path: "/keys"
  @name: "keys_"

  [add: "/add"]: respond_to {
    before: =>
      unless @user
        @write redirect_to: @url_for("user_login", nil, redirect: @url_for "keys_add")

    GET: =>
      @title = "Add Key"
      return render: "keys.add"

    POST: capture_errors {
      on_error: =>
        @info = "The following errors occurred:"
        for err in *@errors
          @info = " #{err}"
        return render: "keys.add"

      =>
        @params.type = tonumber @params.type
        assert_valid @params, key_validations

        assert_error Keys\create {
          user_id: @user.id
          item: @params.item
          key: @params.key
          type: Keys.types\for_db(@params.type)
          status: Keys.statuses\for_db("unclaimed")
        }

        @session.info = "Key added!"
        return redirect_to: @url_for "keys_list"
    }
  }

  [list: "(/list)"]: =>
    @title = "Unclaimed Keys"
    @keys = Keys\select "WHERE status = ? ORDER BY item ASC", Keys.statuses\for_db("unclaimed")
    return render: "keys.list"

  [edit: "/list/edit"]: respond_to {
    before: =>
      unless @user
        @write redirect_to: @url_for("user_login", nil, redirect: @url_for "keys_edit")
      unless @user.admin
        @session.info = "You do not have permission to edit keys."
        @write redirect_to: @url_for "index"

    GET: =>
      @keys = Keys\select "* ORDER BY status ASC, item ASC"
      @title = "Edit Keys"
      return render: "keys.edit"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info = " #{err}"
        return redirect_to: @url_for "keys_edit"

      =>
        key = assert_error Keys\find id: @params.id
        if @params.delete
          assert_error key\delete!
        else
          @params.type = tonumber @params.type
          assert_valid @params, key_validations

          assert_error key\update {
            item: @params.item
            key: @params.key
            type: Keys.types\for_db(@params.type)
            status: Keys.statuses\for_db(@params.status)
            recipient: @params.recipient
          }

        @session.info = "Key updated."
        return redirect_to: @url_for "keys_edit"
    }
  }

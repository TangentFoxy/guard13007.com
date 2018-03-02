lapis = require "lapis"

import respond_to, capture_errors, assert_error from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"

validate_functions.within = (input, tab) ->
  return tab[input] != nil

import GameKeys from require "models"

class extends lapis.Application
  @path: "/keys"
  @name: "game_keys_"

  [add: "/add"]: respond_to {
    before: =>
      unless @user
        @write redirect_to: @url_for "user_login", nil, redirect: @url_for "game_keys_add"

    GET: =>
      @title = "Add Game Key"
      return render: "game_keys.add"

    POST: capture_errors {
      on_error: =>
        @info = "The following errors occurred:"
        for err in *@errors
          @info = " #{err}"
        return render: "game_keys.add"

      =>
        @params.type = tonumber @params.type
        assert_valid @params, {
          {"item", exists: true, "You must enter the game/bundle/whatever this key is for."}
          {"key", exists: true, "You must enter the key/URL/whatever that unlocks whatever its for. o.o"}
          {"type", exists: true, "You must select a key type."}
          -- {"type", within: GameKeys.types, "Invalid key type."}
        }

        if true
          return json: { params: @params }

        assert_error GameKeys\create {
          user_id: @user.id
          item: @params.item
          key: @params.key
          type: GameKeys.types.for_db(@params.type)
          status: GameKeys.statuses.unclaimed
        }

        @session.info = "Key added!"
        return redirect_to: @url_for "game_keys_list"
    }
  }

  [list: "/list"]: =>
    @title = "Game Keys"
    @keys = GameKeys\select "WHERE status = ? ORDER BY item ASC", GameKeys.statuses.unclaimed
    return render: "game_keys.list"

  [edit: "/list/edit"]: respond_to {
    before: =>
      unless @user
        @write redirect_to: @url_for "user_login", nil, redirect: @url_for "game_keys_edit"
      unless @user.admin
        @session.info = "You do not have permission to edit game keys."
        @write redirect_to: @url_for "index"

    GET: =>
      @keys = GameKeys\select "* ORDER BY status ASC, item ASC"
      @title = "Edit Game Keys"
      return render: "game_keys.edit"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info = " #{err}"
        return redirect_to: @url_for "game_keys_edit"

      =>
        key = assert_error GameKeys\find id: @params.id
        if @params.delete
          assert_error key\delete!
        else
          assert_valid @params, {
            {"item", exists: true, "You must enter the game/bundle/whatever this key is for."}
            {"key", exists: true, "You must enter the key/URL/whatever that unlocks whatever its for. o.o"}
            {"type", exists: true, "You must select a key type."}
            -- {"type", within: GameKeys.types, "Invalid key type."}
          }

          assert_error key\update {
            item: @params.item
            key: @params.key
            type: GameKeys.types.for_db(@params.type)
            status: @params.status
            recipient: @params.recipient
          }

        @info = "Key updated."
        return render: "game_keys.edit"
    }
  }

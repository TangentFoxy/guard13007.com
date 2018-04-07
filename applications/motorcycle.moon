lapis = require "lapis"

import require_login, show_errors from require "helpers.route_handling"
import assert_error from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"
import locate from require "locator"
import for_db from locate "datetime"
import date, time from os

import MotorcycleEvents from require "models"

class extends lapis.Application
  @path: "/motorcycle"
  @name: "motorcycle_"

  [add: "/add"]: require_login {
    GET: =>
      @title = "Add Motorcycle Events"
      return render: "motorcycle.add"

    POST: show_errors {
      =>
        for name in *{"odometer", "event", "amount", "cost"}
          @params[name] = tonumber @params[name]
        assert_valid @params, {
          {"odometer", exists: true, "You must enter an odometer value."}
          {"event", exists: true, "You must choose an event type."}
          -- {"amount", exists: true, "You must enter an amount."}
          {"cost", exists: true, "You must enter a cost."}
          {"date", exists: true, "You must enter a date."}
        }

        month, day, year = @params.date\match "(%d%d)/(%d%d)/(%d%d%d%d)"
        assert_error MotorcycleEvents\create {
          user_id: @user.id
          odometer: @params.odometer
          event: MotorcycleEvents\for_db(@params.event)
          amount: @params.amount
          cost: @params.cost
          date: date "!%Y-%m-%d %X", time(:year, :month, :day)
        }

        @session.info = "Event added!"
        return redirect_to: @url_for "motorcycle_list"
    }
  }

  [list: ""]: require_login {
    GET: =>
      @title = "Motorcycle History"
      @events = MotorcycleEvents\select "WHERE user_id = ? ORDER BY date ASC", @user.id
      return render: "motorcycle.list"
  }

  [edit: "/edit"]: require_login {
    GET: =>
      return status: 501, "Not implemented."
    POST: show_errors {
      =>
        return status: 501, "Not implemented."
    }
  }

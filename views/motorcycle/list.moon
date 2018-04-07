import Widget from require "lapis.html"

import MotorcycleEvents from require "models"
import autoload from require "locator"
import MotorcycleMenu from autoload "widgets"

class extends Widget
  content: =>
    widget MotorcycleMenu

    element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      tr ->
        th "Odometer"
        th "Event"
        th "Amount"
        th "Cost"
        th "Date"
      for event in *@events
        tr ->
          td event.odometer
          td MotorcycleEvents.events[event.event]
          td event.amount
          td "$#{event.cost}"
          td event.date

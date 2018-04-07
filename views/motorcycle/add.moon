import Widget from require "lapis.html"

import MotorcycleEvents from require "models"
import autoload from require "locator"
import MotorcycleMenu from autoload "widgets"

class extends Widget
  content: =>
    widget MotorcycleMenu

    form {
      action: @url_for "motorcycle_add"
      method: "POST"
      enctype: "multipart/form-data"
    }, ->
      div class: "field has-addons", ->
        -- odometer, event, amount, date
        div class: "control", ->
          input class: "input", type: "number", step: "0.1", name: "odometer", placeholder: "odometer", value: @params.odometer
        div class: "control", ->
          div class: "select", ->
            element "select", name: "event", ->
              for event in *MotorcycleEvents.events
                e = MotorcycleEvents.events[event]
                if @params.event and e == @params.event
                  option value: e, selected: true, event
                elseif (not @params.event) and event == MotorcycleEvents.events.gas
                  option value: e, selected: true, event
                else
                  option value: e, event
        div class: "control", ->
          div class: "input", type: "number", step: "0.001", name: "amount", placeholder: "amount", value: @params.amount
        div class: "control", ->
          div class: "input", type: "number", step: "0.01", name: "cost", placeholder: "cost", value: @params.cost
        div class: "control", ->
          input class: "input", type: "date", name: "date", placeholder: "mm/dd/yyyy", value: @params.date or os.date "!%m/%d/%Y", os.time!
        div class: "control", ->
          input class: "input", type: "submit", value: "Submit"

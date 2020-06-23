import Widget from require "lapis.html"
import Crafts from require "models"
import KSPCraftsNavWidget from require "widgets"

class KSPCraftsList extends Widget
  content: =>
    widget KSPCraftsNavWidget
    br!

    if @crafts and #@crafts > 0
      link rel: "stylesheet", href: "/static/css/ksp.css"
      element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
        thead ->
          tr ->
            th "Craft"
            th "KSP version"
            th "Status"
            th "Notes"
        tfoot ->
          tr ->
            th "Craft"
            th "KSP version"
            th "Status"
            th "Notes"
        tbody ->
          for craft in *@crafts
            tr ->
              td ->
                a href: @url_for("ksp_crafts_view", id: craft.id), craft.name
              td craft.ksp_version
              status = Crafts.statuses\to_name craft.status
              td class: status, status
              if Crafts.statuses.reviewed == craft.status
                td -> ah ref: "https://youtube.com/watch?v=#{craft.episode}", target: "_blank", "Watch on YouTube"
              else
                td craft.notes

    else
      p "You have not submitted any crafts."

import Widget from require "lapis.html"
import Crafts, Users from require "models"
import Pagination, KSPCraftsNavWidget from require "widgets"

class KSPCraftsIndex extends Widget
  tabs: {
    { name: "All", tip: "All crafts" }
    { name: "Reviewed", tip: "Reviewed on YouTube" }
    { name: "Pending", tip: "Priority, pending, imported, delayed, old" }
    { name: "New", tip: "Just submitted" }
    { name: "Rejected", tip: "Rejected crafts, periodically deleted" }
  }

  content: =>
    widget KSPCraftsNavWidget

    link rel: "stylesheet", href: "/static/css/ksp.css"
    element "table", ->
      tr ->
        real_tab = false -- used to give a "menu item" for sorting via a tag
        @params.tab = "all" unless @params.tab
        for tab in *KSPCraftsIndex.tabs
          if @params.tab == tab.name\lower!
            td tab.name
            real_tab = true
          else
            td -> a href: @url_for("ksp_crafts_index", tab: tab.name\lower!), tab.name
        td -> a href: @url_for("ksp_crafts_tags_index"), "Tags"
        unless real_tab
          td -> a "##{@params.tab}"
        td ->
          form onsubmit: "location.href = '#{@url_for "ksp_crafts_index"}/' + document.getElementById('tag').value; return false;", ->
            input style: "width: 50%; border: none;", type: "text", id: "tag", placeholder: "list by tag"
            input style: "border: none;", type: "submit", value: "⏎"

    if #@crafts < 1
      p "No crafts here. :("

    else
      widget Pagination

      element "table", ->
        thead ->
          tr ->
            th style: "width: 20%; word-wrap: break-word;", "Craft"
            th style: "width: 20%; word-wrap: break-word;", "Creator"
            th style: "width: 10%;", "Status"
            th "YouTube Link / Notes"
        tfoot ->
          tr ->
            th style: "width: 20%; word-wrap: break-word;", "Craft"
            th style: "width: 20%; word-wrap: break-word;", "Creator"
            th "Status"
            th "YouTube Link / Notes"
        tbody ->
          the_date = os.date "!*t", os.time!
          for craft in *@crafts
            tr ->
              td style: "width: 20%; word-wrap: break-word;", -> a href: @url_for("ksp_crafts_view", id: craft.id), craft.name
              name = craft.creator
              if the_date.month == 4 and the_date.day == 1
                name = "John"
              elseif craft.user_id != 0
                if user = Users\find id: craft.user_id
                  name = user.name
              td style: "width: 20%; word-wrap: break-word;", name
              status = Crafts.statuses\to_name craft.status
              td style: "width: 10%;", class: status, status
              if Crafts.statuses.reviewed == craft.status
                td -> a href: "https://youtube.com/watch?v=#{craft.episode}", target: "_blank", "Watch on YouTube"
              else
                td craft.notes

      widget Pagination

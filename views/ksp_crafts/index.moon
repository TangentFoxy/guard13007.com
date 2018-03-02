import Widget from require "lapis.html"
import Crafts, Users from require "models"
import autoload from require "locator"
import Pagination, KSPCraftsNavWidget from autoload "widgets"

class KSPCraftsIndex extends Widget
  tabs: {
    {name: "All", tip: "All crafts in the order they were submitted."}
    {name: "Reviewed", tip: "Crafts which have been reviewed on my YouTube channel."}
    {name: "Pending", tip: "priority: Crafts to be reviewed next.\npending: Crafts awaiting a review.\nimported: Crafts I have imported from the KerbalX hanger or emails.\ndelayed: Craft that will be skipped for now.\nold: Really old submissions."}
    {name: "New", tip: "Crafts that I haven't even noticed have been submitted yet."}
    {name: "Rejected", tip: "Crafts that were rejected from my review series. Periodically deleted."}
  }

  content: =>
    widget KSPCraftsNavWidget

    link rel: "stylesheet", href: "/static/css/ksp.css"
    div class: "tabs is-centered", ->
      ul ->
        real_tab = false
        @params.tab = "all" unless @params.tab
        for tab in *KSPCraftsIndex.tabs
          if @params.tab == tab.name\lower!
            li class: "is-active", -> a tab.name
            real_tab = true
          else
            li -> a href: @url_for("ksp_crafts_index", tab: tab.name\lower!), tab.name
        li -> a href: @url_for("ksp_crafts_tags"), "Tags"
        unless real_tab
          li class: "is-active", -> a "##{@params.tab}"
        li ->
          form onsubmit: "location.href = '#{@url_for "ksp_crafts_index"}/' + document.getElementById('tag').value; return false;", ->
            input style: "width: 50%; border: none;", type: "text", id: "tag", placeholder: "list by tag"
            input style: "border: none;", type: "submit", value: "⏎"

    if #@crafts < 1
      p "There are no crafts matching that criteria."

    else
      widget Pagination
      br!

      element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
        thead ->
          tr ->
            th style: "width: 20%; word-wrap: break-word;", "Craft"
            th style: "width: 20%; word-wrap: break-word;", "Creator"
            th style: "width: 10%;", "Status"
            th "Notes"
        tfoot ->
          tr ->
            th style: "width: 20%; word-wrap: break-word;", "Craft"
            th style: "width: 20%; word-wrap: break-word;", "Creator"
            th "Status"
            th "Notes"
        tbody ->
          the_date = os.date "*t", os.time!
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

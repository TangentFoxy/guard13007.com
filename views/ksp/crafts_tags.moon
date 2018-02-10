import Widget from require "lapis.html"
import Pagination, KSPCraftsSearchWidget from require "widgets"

KSPCraftsIndex = require "views.ksp.crafts_index"

class KSPCraftsTags extends Widget
  content: =>
    widget KSPCraftsSearchWidget

    div class: "tabs is-centered", ->
      ul ->
        for tab in *KSPCraftsIndex.tabs
          li -> a href: @url_for("ksp_crafts_index", tab: tab\lower!), tab
        li class: "is-active", -> a "Tags"
        li ->
          form onsubmit: "location.href = '#{@url_for "ksp_crafts_index"}/' + document.getElementById('tag').value; return false;", ->
            input style: "width: 50%; border: none;", type: "text", id: "tag", placeholder: "list by tag"
            input style: "border: none;", type: "submit", value: "⏎"

    widget Pagination
    br!

    element "table", class: "table is-bordered is-striped is-narrow is-fullwidth", ->
      tbody ->
        for i=1, #@tags, 5
          tr ->
            td ->
              if tag = @tags[i]
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " #{tag.count}"
            td ->
              if tag = @tags[i+1]
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " #{tag.count}"
            td ->
              if tag = @tags[i+2]
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " #{tag.count}"
            td ->
              if tag = @tags[i+3]
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " #{tag.count}"
            td ->
              if tag = @tags[i+4]
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " #{tag.count}"

    widget Pagination

import Widget from require "lapis.html"
import Pagination, KSPCraftsNavWidget from require "widgets"
import ceil from math

KSPCraftsIndex = require "views.ksp_crafts.index"

class KSPCraftsTags extends Widget
  content: =>
    widget KSPCraftsNavWidget

    div class: "tabs is-centered", ->
      ul ->
        for tab in *KSPCraftsIndex.tabs
          li -> a href: @url_for("ksp_crafts_index", tab: tab.name\lower!), tab.name
        li class: "is-active", -> a "Tags"
        li ->
          form onsubmit: "location.href = '#{@url_for "ksp_crafts_index"}/' + document.getElementById('tag').value; return false;", ->
            input style: "width: 50%; border: none;", type: "text", id: "tag", placeholder: "list by tag"
            input style: "border: none;", type: "submit", value: "⏎"

    widget Pagination
    br!

    div class: "columns", ->
      forth = ceil #@tags / 4
      for c=1, 4
        div class: "column", ->
          for i=(c-1)*forth+1, c*forth
            if tag = @tags[i]
              p ->
                a href: @url_for("ksp_crafts_index", tab: tag.name), "##{tag.name}"
                text " (#{tag.count})"

    widget Pagination

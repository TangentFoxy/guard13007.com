import Widget from require "lapis.html"
-- import Posts from require "models"
-- import autoload from require "locator"
-- import Pagination from autoload "widgets"
import remove from table
import ceil from math

class PostIndex extends Widget
  content: =>
    if video = remove @videos, 1
      h1 id: "title", class: "title has-text-centered", video.title
      div class: "yt-embed", ->
        div ->
          iframe id: "video", src: "https://www.youtube.com/embed/#{video.id}", frameborder: 0, allowfullscreen: true
      div id: "description", video.description

    else
      h1 class: "title has-text-centered", "Videos"
      p "There are no videos yet."

    div class: "columns", ->
      forth = ceil #@videos / 4
      for c=1, 4
        div class: "column", ->
          for i=(c-1)*forth+1, c*forth
            if video = @videos[i]
              br!
              div class: "image is16by9", ->
                a onclick: "javascript:v('#{video.id\gsub "'", "\\'"}', '#{video.title\gsub "'", "\\'"}', '#{video.description\gsub("\n", "\\n")\gsub "'", "\\'"}')", ->
                  img src: video.thumbnail
              -- if video.clean
              --   div class: "image is16by9", ->
              --     a onclick: "javascript:v('#{video.id\gsub "'", "\\'"}', '#{video.title\gsub "'", "\\'"}', '#{video.description\gsub("\n", "\\n")\gsub "'", "\\'"}')", ->
              --       img src: video.thumbnail
              -- else
              --   div class: "image is16by9", style: "overflow:hidden;", ->
              --     a onclick: "javascript:v('#{video.id\gsub "'", "\\'"}', '#{video.title\gsub "'", "\\'"}', '#{video.description\gsub("\n", "\\n")\gsub "'", "\\'"}')", ->
              --       img src: video.thumbnail, style: "margin-top:-9.32%;"

    script src: "/static/js/videos/index.js"

import Widget from require "lapis.html"
-- import Posts from require "models"
-- import autoload from require "locator"
-- import Pagination from autoload "widgets"
import remove from table
import ceil from math

class PostIndex extends Widget
  content: =>
    if video = remove @videos, 1
      div class: "yt-embed", ->
        div ->
          iframe src: "https://www.youtube.com/embed/#{video.id}", frameborder: 0, allowfullscreen: true
      div class: "content", -> -- NOTE temporary, very shitty
        h2 video.title
        p video.description

    div class: "columns", ->
      forth = ceil #@videos / 4
      for c=1, 4
        div class: "column", ->
          for i=(c-1)*forth+1, c*forth
            if video = @videos[i]
              div class: "is-16by9", ->
                -- TODO this is where JavaScript should be to trigger sending this to the player above
                img src: video.thumbnail

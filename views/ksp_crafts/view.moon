import Widget from require "lapis.html"
import Crafts, CraftTags, Users from require "models"
import autoload from require "locator"
import KSPCraftsNavWidget from autoload "widgets"

class KSPCraftsView extends Widget
  content: =>
    widget KSPCraftsNavWidget

    link rel: "stylesheet", href: "/static/css/ksp.css"
    link rel: "stylesheet", href: "/static/simplemde/simplemde.min.css"
    script src: "/static/simplemde/simplemde.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script src: "/static/js/marked.min.js"
    script -> raw "uniqueID = 'craft_#{@craft.id}';"
    script src: "/static/js/ksp/crafts_view.js"
    div id: "description", class: "content"
    description = @craft.description\gsub("\\", "\\\\\\\\")\gsub("'", "\\'")\gsub("\n", "\\n")\gsub("\r", "")\gsub("</script>", "</'+'script>")
    script -> raw "document.getElementById('description').innerHTML = marked('#{description}');"

    if Crafts.statuses.reviewed == @craft.status
      div class: "yt-embed", ->
        div -> iframe src: "https://www.youtube.com/embed/#{@craft.episode}", frameborder: 0, allowfullscreen: true

    the_date = os.date "*t", os.time!
    if the_date.month == 4 and the_date.day == 1
      img id: "da_image", src: "https://i.imgur.com/xs190GO.jpg"
      br!
      button class: "button", onclick: "document.getElementById('da_image').src = '#{@craft.picture}';", "Get da real image"
    else
      img src: @craft.picture

    div class: "level", ->
      div class: "level-left", ->
        div class: "level-item", ->
          a class: "button", href: @craft.download_link, target: "_blank", "Download"
        div class: "level-item", ->
          text " KSP Version: #{@craft.ksp_version}"
        div class: "level-item #{Crafts.statuses[@craft.status]}", ->
          strong "Status"
          text ": #{Crafts.statuses[@craft.status]}"
    p "Action Groups:"
    pre style: "white-space: pre-wrap;", @craft.action_groups
    p "Mods Used:"
    pre style: "white-space: pre-wrap;", @craft.mods_used

    if @previous_craft or @next_craft
      div class: "level", ->
        div class: "level-left", ->
          div class: "level-item", ->
            if @previous_craft
              a class: "button", href: @url_for("ksp_crafts_view", id: @previous_craft.id), "Previous Craft"
            else
              a class: "button", disabled: true, "Previous Craft"
        div class: "level-right", ->
          div class: "level-item", ->
            if @next_craft
              a class: "button", href: @url_for("ksp_crafts_view", id: @next_craft.id), "Next Craft"
            else
              a class: "button", disabled: true, "Next Craft"

    hr!
    p "Notes from Guard13007: #{@craft.notes}"

    if @user
      if @user.id == @craft.user_id or @user.admin
        hr!
        form {
          action: @url_for "ksp_crafts_view", id: @craft.id
          method: "POST"
          enctype: "multipart/form-data"
        }, ->
          div class: "field is-grouped is-grouped-centered", ->
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "name", placeholder: "Craft Name", value: @craft.name
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "download_link", placeholder: "Craft Link", value: @craft.download_link
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "picture", placeholder: "Image URL", value: @craft.picture

          div class: "field", ->
            div class: "control", ->
              textarea class: "textarea", rows: 8, name: "description", placeholder: "Description", @craft.description
            div class: "control", ->
              textarea class: "textarea", rows: 2, cols: 60, name: "action_groups", placeholder: "Action Groups", @craft.action_groups

          div class: "field is-grouped is-grouped-centered", ->
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "ksp_version", placeholder: "KSP Version", value: @craft.ksp_version
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "mods_used", placeholder: "Mods Used", value: @craft.mods_used
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "tags", placeholder: "space-separated tags go here", value: CraftTags\to_string craft_id: @craft.id

          div class: "control", ->
            div class: "buttons is-centered", ->
              input class: "button", type: "submit", value: "Update"

      if @user.admin
        hr!
        form {
          action: @url_for "ksp_crafts_view", id: @craft.id
          method: "POST"
          enctype: "multipart/form-data"
        }, ->
          div class: "field is-grouped is-grouped-centered", ->
            div class: "control is-expanded", ->
              div class: "select", ->
                element "select", name: "status", ->
                  option value: 0, "new" -- hardcoded :/
                  for status in *Crafts.statuses
                    if status == Crafts.statuses[@craft.status]
                      option value: Crafts.statuses[status], selected: true, status
                    else
                      option value: Crafts.statuses[status], status
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "episode", placeholder: @craft.episode
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "tags", placeholder: "tags", value: CraftTags\to_string craft_id: @craft.id

          div class: "field is-grouped is-grouped-centered", ->
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "creator", placeholder: "Creator", value: @craft.creator
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "user_id", value: @craft.user_id
            div class: "control is-expanded", ->
              input class: "input", type: "text", name: "notes", placeholder: "Notes", value: @craft.notes

          div class: "control", ->
            input class: "button", type: "submit", value: "Update"

        hr!
        form {
          action: @url_for "ksp_crafts_view", id: @craft.id
          method: "POST"
          enctype: "multipart/form-data"
          onsubmit: "return confirm('Are you sure you want to do this?');"
        }, ->
          text "Delete craft? "
          input type: "checkbox", name: "delete"
          br!
          input type: "submit"

    hr!
    div id: "disqus_thread"
    script -> raw "
      var disqus_config = function () {
        this.page.url = 'https://guard13007.com/ksp/craft/#{@craft.id}';
        this.page.identifier = 'https://guard13007.com:8150/ksp/craft/#{@craft.id}';
      };
      (function() {
        var d = document, s = d.createElement('script');
        s.src = '//guard13007.disqus.com/embed.js';
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
      })();
    "

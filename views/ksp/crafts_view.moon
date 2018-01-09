import Widget from require "lapis.html"
import Crafts, Users from require "models"
import KSPCraftsSearchWidget from require "widgets"

class KSPCraftsView extends Widget
  content: =>
    widget KSPCraftsSearchWidget

    script src: "/static/js/marked.min.js"
    link rel: "stylesheet", href: "/static/highlight/styles/solarized-dark.css"
    script src: "/static/highlight/highlight.pack.js"
    script -> raw "
      marked.setOptions({
        highlight: function(code) { return hljs.highlightAuto(code).value; },
        sanitize: true,
        smartypants: true
      });
      hljs.initHighlightingOnLoad();
    "
    div id: "description"
    description = @craft.description\gsub("\\", "\\\\\\\\")\gsub("'", "\\'")\gsub("\n", "\\n")\gsub("\r", "")\gsub("</script>", "</'+'script>")
    script -> raw "document.getElementById('description').innerHTML = marked('#{description}');"

    if Crafts.statuses.reviewed == @craft.status
      div class: "yt-embed", -> iframe src: "https://www.youtube.com/embed/#{@craft.episode}", frameborder: 0, allowfullscreen: true

    the_date = os.date "*t", os.time!
    if the_date.month == 4 and the_date.day == 1
      img id: "da_image", src: "https://i.imgur.com/xs190GO.jpg"
      br!
      button class: "button", onclick: "document.getElementById('da_image').src = '#{@craft.picture}';", "Get da real image"
    else
      img src: @craft.picture

    p ->
      a class: "button", href: @craft.download_link, target: "_blank", "Download"
      text " KSP Version: #{@craft.ksp_version}"
    p "Action Groups:"
    pre style: "white-space: pre-wrap;", @craft.action_groups
    p "Mods Used:"
    pre style: "white-space: pre-wrap;", @craft.mods_used
    hr!
    p "Notes from Guard13007: #{@craft.notes}"

    if @session.id
      if user = Users\find id: @session.id
        if @session.id == @craft.user_id or user.admin
          hr!
          p "TODO: Form for editing the submission."

        if user.admin
          hr!
          p "TODO: Form for editing as admin."

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

                        --     form {
                        --         action: @url_for "ksp_craft", id: craft.id
                        --         method: "POST"
                        --         enctype: "multipart/form-data"
                        --     }, ->
                        --         text "Craft name: "
                        --         input type: "text", name: "craft_name", value: craft.craft_name
                        --         br!
                        --         p "Description:"
                        --         textarea cols: 60, rows: 5, name: "description", craft.description
                        --         br!
                        --         text "Craft link: "
                        --         input type: "text", name: "download_link", value: craft.download_link
                        --         br!
                        --         text "Image URL: "
                        --         input type: "text", name: "picture", value: craft.picture
                        --         br!
                        --         p "Action groups:"
                        --         textarea cols: 60, rows: 3, name: "action_groups", craft.action_groups
                        --         br!
                        --         text "KSP version: "
                        --         input type: "text", name: "ksp_version", value: craft.ksp_version
                        --         br!
                        --         text "Mods used: "
                        --         input type: "text", name: "mods_used", value: craft.mods_used
                        --         br!
                        --         input type: "submit"
                        --
                        -- if user.admin
                        --     hr!
                        --     form {
                        --         action: @url_for "ksp_craft", id: craft.id
                        --         method: "POST"
                        --         enctype: "multipart/form-data"
                        --     }, ->
                        --         text "Status: "
                        --         element "select", name: "status", ->
                        --             option value: 0, "new" -- shoddy work-around on my part...
                        --             for status in *Crafts.statuses
                        --                 if status == Crafts.statuses[craft.status]
                        --                     option value: Crafts.statuses[status], selected: true, status
                        --                 else
                        --                     option value: Crafts.statuses[status], status
                        --         text " Episode: "
                        --         input type: "text", name: "episode", placeholder: craft.episode
                        --         text " Notes: "
                        --         input type: "text", name: "notes", value: craft.notes
                        --         br!
                        --         text "Creator name: "
                        --         input type: "text", name: "creator_name", value: craft.creator_name
                        --         br!
                        --         text "User ID: "
                        --         input type: "number", name: "user_id", value: craft.user_id
                        --         br!
                        --         input type: "submit"
                        --
                        --     hr!
                        --     form {
                        --         action: @url_for "ksp_craft", id: craft.id
                        --         method: "POST"
                        --         enctype: "multipart/form-data"
                        --         onsubmit: "return confirm('Are you sure you want to do this?');"
                        --     }, ->
                        --         text "Delete craft? "
                        --         input type: "checkbox", name: "delete"
                        --         br!
                        --         input type: "submit"

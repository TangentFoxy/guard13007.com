import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"
import locate from require "locator"
import pretty_date from require "datetime"

class ViewPost extends Widget
  content: =>
    div class: "container has-text-centered", ->
      h2 class: "subtitle", "Last modified #{time_ago_in_words @post.updated_at, 2}"
    div class: "content", ->
      raw @post.html
    div class: "container has-text-centered", ->
      h2 class: "subtitle", "Originally published #{pretty_date @post.published_at}"
      if @user and @user.admin
        a class: "button", href: @url_for("posts_edit", id: @post.id), "Edit Post"
    div id: "disqus_thread"
    script -> raw "
      var disqus_config = function () {
        this.page.url = 'https://guard13007.com#{@url_for "posts_view", slug: @post.slug}';
        this.page.identifier = 'https://guard13007.com#{@url_for "posts_view", slug: @post.slug}';
      };
      (function() {
        var d = document, s = d.createElement('script');
        s.src = '//guard13007.disqus.com/embed.js';
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
      })();"

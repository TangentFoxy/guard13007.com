lapis = require "lapis"

class extends lapis.Application
    "/greyout": =>
        @title = "What is #TwitterGreyout?"
        @html ->
            p ->
                text "There's a protest about Donald Trump winning the election at "
                a href: "https://twitter.com/hashtag/TwitterBlackout", target: "_blank", "#TwitterBlackout"
                text ", but I think it's far more important to address the fact that the USA's voting system is garbage. So I'm trying to get "
                a href: "https://twitter.com/hashtag/TwitterGreyout", target: "_blank", "#TwitterGreyout"
                text " started. Let's talk about why we only have two real choices in an election, or if the electoral college should be abolished."
            p ->
                text "Talk about this with the hashtag #TwitterGreyout, switch your avatar to "
                a href: ("/static/img/greyout.png"), target: "_blank", "this"
                text ", and mention "
                a href: "https://twitter.com/Guard13007", target: "_blank", "@Guard13007"
                text " a bunch! Or whoever, come on!"
            hr!
            p "Here are a couple videos that I'd like to share as a beginning to discussion on the topic:"
            p "(Please comment more below! I'd love to have more stuff to put here, especially if it is in opposition to what I think!)"
            div class: "yt-embed", ->
                iframe src: "https://www.youtube.com/embed/reUJAS8dsSM", frameborder: 0, allowfullscreen: true
            div class: "yt-embed", ->
                iframe src: "https://www.youtube.com/embed/s7tWHJfhiyo", frameborder: 0, allowfullscreen: true
            div class: "yt-embed", ->
                iframe src: "https://www.youtube.com/embed/l8XOZJkozfI", frameborder: 0, allowfullscreen: true
            hr!
            div id: "disqus_thread"
            script -> raw "
                var disqus_config = function () {
                    this.page.url = 'https://guard13007.com/greyout';
                    this.page.identifier = 'https://guard13007.com:8150/greyout';
                };
                (function() {
                    var d = document, s = d.createElement('script');
                    s.src = '//guard13007.disqus.com/embed.js';
                    s.setAttribute('data-timestamp', +new Date());
                    (d.head || d.body).appendChild(s);
                })();"

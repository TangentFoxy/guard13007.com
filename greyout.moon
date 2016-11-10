lapis = require "lapis"

class extends lapis.Application
    "/greyout": =>
        @title = "What is #TwitterGreyout?"
        @html ->
            p ->
                text "There's a protest about Donald Trump winning the election at "
                a href: "https://twitter.com/search?q=%23TwitterBlackout&src=typd", target: "_blank", "#TwitterBlackout"
                text ", but I think it's far more important to address the fact that the USA's voting system is garbage. So I'm trying to get "
                a href: "https://twitter.com/search?f=tweets&q=%23TwitterGreyout&src=typd", target: "_blank", "#TwitterGreyout"
                text " started. Let's talk about why we only have two real choices in an election, or if the electoral college should be abolished."
                hr!
                div class: "yt-embed", ->
                    iframe src: "https://www.youtube.com/embed/reUJAS8dsSM", frameborder: 0, allowfullscreen: true
                    iframe src: "https://www.youtube.com/embed/s7tWHJfhiyo", frameborder: 0, allowfullscreen: true
                    iframe src: "https://www.youtube.com/embed/l8XOZJkozfI", frameborder: 0, allowfullscreen: true
                hr!
                div id: "disqus_thread"
                script -> raw "
                    var disqus_config = function () {
                        this.page.url = '#{@build_url "/greyout"}';
                        this.page.identifier = '#{@build_url "/greyout"}';
                    };
                    (function() {
                        var d = document, s = d.createElement('script');
                        s.src = '//guard13007.disqus.com/embed.js';
                        s.setAttribute('data-timestamp', +new Date());
                        (d.head || d.body).appendChild(s);
                    })();"

lapis = require "lapis"

import respond_to from require "lapis.application"

Cards = require "models.Cards"
CardVotes = require "models.CardVotes"

class extends lapis.Application
    @path: "/cards/1000"
    @name: "cards_1000_"

    [list: "(/:page[%d])"]: =>
        cards = Cards\paginated "* ORDER BY rating DESC", per_page: 24 -- divisible by 3, 4, and 6
        page = tonumber(@params.page) or 1
        cards = cards\get_page page

        @html ->
            link rel: "stylesheet", href: @build_url "static/css/pure-responsive-grids.css"
            div class: "pure-g", ->
                for card in *cards
                    div class: "pure-u-1 pure-u-sm-1-2 pure-u-md-1-3 pure-u-lg-1-4 pure-u-xl-1-6", ->
                        -- id, user_id, title, artwork, description, point_value, rating
                        h2 card.title
                        img src: card.artwork
                        div card.description
                        div class: "card_bottom", ->
                            div class: "left", card.point_value
                            div class: "right", card.rating

    [card: "/card/:id[%d]"]: =>
        if card = Cards\find id: id
            @html ->
                h2 card.title
                img src: card.artwork
                div card.description
                div class: "card_bottom", ->
                    div class: "left", card.point_value
                    div class: "right", card.rating
        else
            redirect_to: @url_for "cards_1000_list"

    [create: "/create"]: respond_to {
        GET: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            @html ->
                link href: @build_url "/static/literallycanvas/literallycanvas.css"
                script src: @build_url "/static/literallycanvas/react-with-addons.js"
                script src: @build_url "/static/literallycanvas/react-dom.js"
                script src: @build_url "/static/literallycanvas/literallycanvas.min.js"

                form {
                    class: "pure-form"
                    action: @url_for "cards_1000_create"
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    input type: "text", name: "title", placeholder: "Title"
                    input type: "text", name: "description", placeholder: "Description"
                    input type: "number", name: "point_value", placeholder: "100"
                    input type: "submit", value: "Submit", class: "pure-button", onclick: "artwork.getImage();"
                div class: "artwork"

                script -> raw "
                    window.onload = function() {
                        var artwork = LC.init(
                            document.getElementsByClassName('artwork')[0],
                            {
                                imageURLPrefix: '/static/literallycanvas/img',
                                imageSize: {width: 400, height: 400}
                            }
                        );
                    }
                "
        POST: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            card, errMsg = Cards\create {
                user_id: @session.id
                title: @params.title
                artwork: @params.artwork
                description: @params.description
                point_value: tonumber @params.point_value
                rating: 0
            }

            if card
                return redirect_to: @url_for "cards_1000_card", id: card.id
            else
                @session.info = "Card submission failed: #{errMsg}"
                return redirect_to: @url_for "cards_1000_create"
    }

    [edit: "/edit"]: respond_to {
        GET: =>
            --
        POST: =>
            --
    }

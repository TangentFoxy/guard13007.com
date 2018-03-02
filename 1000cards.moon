lapis = require "lapis"
http = require "lapis.nginx.http"

import respond_to from require "lapis.application"
import locate from require "locator"
import starts from locate "gstring"

import Cards, CardVotes from require "models"

class extends lapis.Application
    @path: "/cards/1000"
    @name: "cards_1000_"

    [list: "(/:page[%d])"]: =>
        cards = Cards\paginated "* ORDER BY rating DESC", per_page: 24 -- divisible by 3, 4, and 6
        page = tonumber(@params.page) or 1
        cards = cards\get_page page

        @html ->
            link rel: "stylesheet", href:  "/static/css/pure-responsive-grids.css"
            div class: "pure-g", ->
                for card in *cards
                    div class: "pure-u-1 pure-u-sm-1-2 pure-u-md-1-3 pure-u-lg-1-4 pure-u-xl-1-6", ->
                        -- id, user_id, title, artwork, description, point_value, rating
                        h2 card.title
                        img src: card.artwork, width: "100%"--, height: 400
                        div card.description
                        div class: "card_bottom", ->
                            div class: "left", card.point_value
                            div class: "right", card.rating

    [card: "/card/:id[%d]"]: =>
        if card = Cards\find id: @params.id
            @html ->
                h2 card.title
                img src: card.artwork, width: "100%"--, height: 400
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
                form {
                    class: "pure-form"
                    action: @url_for "cards_1000_create"
                    method: "POST"
                    enctype: "multipart/form-data"
                }, ->
                    input type: "text", name: "title", placeholder: "Title"
                    input type: "text", name: "description", placeholder: "Description"
                    input type: "text", name: "artwork", placeholder: "URL for card artwork"
                    input type: "number", name: "point_value", placeholder: "0"
                    input type: "submit", value: "Submit", class: "pure-button"

        POST: =>
            unless @session.id
                return redirect_to: @url_for "user_login"

            --TODO turn this kind of code into a utility thing for verifying images
            -- (and just check MIME types already ?)
            -- this code should also be in the model, not here
            if @params.artwork\len! > 0
                if @params.artwork\sub(1, 7) == "http://"
                    @params.artwork = "https://#{@params.artwork\sub 8}"
                t = @params.artwork
                if starts(t,"https://dropbox.com") or starts(t,"https://www.dropbox.com")
                    @session.info = "Dropbox cannot be used to host images."
                    return redirect_to: @url_for "cards_1000_create"
                if starts(t,"https://youtube.com") or starts(t,"https://www.youtube.com")
                    @session.info = "YouTube cannot be used to host images.."
                    return redirect_to: @url_for "cards_1000_create"
                if starts(t,"https://imgur.com/a/") or starts(t,"https://imgur.com/gallery/")
                    @session.info = "Use the direct link to an image on Imgur, not an album."
                    return redirect_to: @url_for "cards_1000_create"
                if starts(t,"https://images.akamai.steamusercontent.com")
                    @session.info = "Steam's user images are not securely served, so I cannot accept them."
                    return redirect_to: @url_for "cards_1000_create"
                --if starts(t,"https://imgur.com/")
                    -- TODO fix with a PNG, JPG, or GIF extension and i.imgur.com
                _, http_status = http.simple @params.artwork
                -- TODO log all http_status checks here to compare for what I should allow and disallow
                if http_status == 404 or http_status == 403 or http_status == 500 or http_status == 301 or http_status == 302
                    @session.info = "Card submission failed: Artwork URL is invalid."
                    return redirect_to: @url_for "cards_1000_create"
            else
                @params.artwork = "https://guard13007.com/static/img/aaa-1x1.png"

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

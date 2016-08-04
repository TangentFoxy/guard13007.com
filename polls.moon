lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"

class extends lapis.Application
    @path: "/polls"
    @name: "polls_"

    [index: "/"]: =>
        @title = "Guard's Polls"
        @html ->
            ul ->
                li ->
                    a href: @url_for("polls_yt_videos"), "What type of videos should I make?"
                    ul ->
                        li ->
                            a href: @url_for("polls_yt_games"), "What type of gaming videos should I make?"
                            ul ->
                                li ->
                                    a href: @url_for("polls_yt_ksp"), "What kind of KSP videos should I make?"

    [yt_videos: "/youtube-videos.html"]: =>
        @title = "What type of YouTube videos should I make?"
        @poll = "https://www.strawpoll.me/embed_1/6279645"
        render: "poll"

    [yt_games: "/youtube-games.html"]: =>
        @title = "What kind of gaming videos should I make?"
        @poll = "https://www.strawpoll.me/embed_1/6279645"
        render: "poll"

        --<div>
    	--	<h2>Other suggestions recieved so far:</h2>
    	--	<ul>
    	--		<li>Some horror game (perhaps Alan Wake)</li>
    	--		<li>MC: Have viewers suggest things to build.</li>
    	--		<li>Orbiter 2010</li>
    	--		<li>Five Nights at Freddies</li>
    	--		<li>Europa Universalis 4</li>
    	--		<li>Simple Planes</li>
    	--		<li><a href="https://unrealworld.fi/">UnReal World RPG</a>, whatever that is</li>
    	--		<li>Unholy Heights</li>
    	--		<li>Space Engineers</li>
    	--		<li>Elite Dangerous</li>
    	--		<li>War Thunder</li>

    [yt_ksp: "/ksp-stuff.html"]: =>
        @title = "What kind of KSP videos should I make?"
        @poll = "https://www.strawpoll.me/embed_1/3301812"
        render: "poll"

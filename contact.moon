lapis = require "lapis"

class extends lapis.Application
  [chat_rules: "/chat/rules"]: =>
    @title = "Guard's Discord - Rules"
    @html ->
      ol ->
        li "Do not post links to pirated software. You can discuss piracy, but do not link to illegal downloads."
        li "No constant advertising. It's fine to tell people you have a YouTube channel or are working on something, but do not mention it constantly."
        li "By default, no one can post links except in the #picsandlinks and #shitpost channels. If you build up trust, you will be allowed to post in other channels."
        li "No copypasta."
        li ->
          text "The channels:"
          ul ->
            li "#general is for general conversation and where we most often chat."
            li "#computers-n-code is for programming, hacking, code, other technological items or discussions."
            li "#trusted is a private channel for people I trust."
            li "#music is for sharing music! :D"
            li "#art is for sharing art."
            li "#bot-abuse is for playing with BoomBot, developed by Lomeli. :P"
            li "#picsandlinks is for sharing stuff, as long as it's not crap."
            li "#shitpost is for random crap..since some people want that for some reason. >.>"
        li "Racism is bad. Let's just not have it."
        li "Please refrain from using offensive language meant to provoke an argument with no constructive purpose."
        hr!
        li "More rules may be added as needed, obviously."
        li title: "If you don't like it, see http://xkcd.com/1357/", "And finally, if you are causing significant annoyance to several members, especially if they are friends of mine, I may ban you."

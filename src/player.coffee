command = require('./cmd')
spells = require('./spells')
{Entity} = require('./entity')
Milk = require('../lib/milk')
World = require('./world')

class Player extends Entity
    constructor: (@client) ->
        super()
        @isDisconnected = false
        @name = Math.random()

        @client.on 'end', () =>
            @isDisconnected = true

    handleEvent: (event, sender, args) ->
        movementHandler = (verb) =>
            if sender isnt this
                @writeLine "#{sender.name} #{verb} the room."

        switch event
            when "leaveRoom" then movementHandler("left")
            when "enterRoom" then movementHandler("entered")

    move: (direction) ->
        nextRoom = @room.followLink direction

        if nextRoom
            World.moveEntity this, nextRoom
            @look()
        else
            @writeLine "You can't go that way"


    look: () ->

        data = {
            id: @room.id
            title: @room.title
            entities: (block) =>
                result = (Milk.render block, entity \
                    for entity in @room.entities when entity isnt this).join("")

                if result.length != 0 then result += "\n"
            exits: () =>
                link for link of @room.links


        }

        template = """
        You are in room \#{{id}}
        {{title}}

        {{#entities}}
        A {{name}} stands here.
        {{/entities}}
        Exits: [{{exits}}]
        """

        @writeLine Milk.render template, data


    showPrompt: () ->
        @write("> ")

    write: (str) ->
        if not @isDisconnected
            @client.write str

    writeLine: (str) ->
        if not @isDisconnected
            @client.writeLine str

    disconnect: (message) ->
        @client.end message
        @isDisconnected = true


#
# Commands
#
genmove = (dir) ->
    (player) -> player.move dir


command.register "north", ["n"], genmove('n')
command.register "east", ["e"], genmove('e')
command.register "south", ["s"], genmove('s')
command.register "west", ["w"], genmove('w')
command.register "quit", null, (player) -> player.disconnect "goodbye."
command.register "say", ["^'"], (player, args) ->
    if args.length == 0
        player.writeLine "What would you like to say?"
    else
        spells.speak.cast(player, args)

command.register "look", ["l"], (player) -> player.look()
command.register "exits", ["exit"], (player) -> player.look()
exports.Player = Player

command = require('./cmd')
spells = require('./spells')

class Player
    constructor: (@client) ->
        @isDisconnected = false

        @client.on 'end', () =>
            @isDisconnected = true

    move: (world, direction) ->
        nextRoom = @room.followLink direction

        if nextRoom
            world.moveEntity this, nextRoom
            @look()
        else
            @writeLine "You can't go that way"

    look: () ->

        @writeLine \
            """You are in room #{@room.id}
               #{@room.title}

               Exits: [#{e for e of @room.links}]"""

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
    (context) -> context.player.move context.world, dir


command.register "north", ["n"], genmove('n')
command.register "east", ["e"], genmove('e')
command.register "south", ["s"], genmove('s')
command.register "west", ["w"], genmove('w')
command.register "quit", null, (context) -> context.player.disconnect "goodbye."
command.register "say", ["^'"], (context, args) ->
    if args.length == 0
        context.player.writeLine "What would you like to say?"
    else
        spells.speak.cast(context.world, context.player, args)

command.register "look", ["l"], (context) -> context.player.look()
command.register "exits", ["exit"], (context) -> context.player.look()
exports.Player = Player

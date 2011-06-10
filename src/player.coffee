command = require('./cmd')

class Player
    constructor: (@client, @db) ->
        @room = @db[1]
        @isDisconnected = false

        @client.on 'end', () =>
            @isDisconnected = true

    move: (direction) ->
        nextRoomId = @room.links[direction]
        if nextRoomId?
            @room = @db[nextRoomId]
            @look()
        else
            @writeLine "You can't go that way"

    look: () ->
        @writeLine "You are in room #{@room.id}"
        @writeLine @room.title
        @writeLine()
        @writeLine "Exits: [#{e for e of @room.links}]"

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
    (context) ->
        context.player.move dir

command.register "north", ["n"], genmove('n')
command.register "east", ["e"], genmove('e')
command.register "south", ["s"], genmove('s')
command.register "west", ["w"], genmove('w')
command.register "quit", null, (context) -> context.player.disconnect "goodbye."
command.register "say", ["^'"], (context, args) ->
    if args.length == 0
        context.player.writeLine "What would you like to say?"
    else
        context.player.writeLine "You say, \"#{args}\""
        for player in context.playerList
            do (player) ->
                unless player == context.player
                    player.writeLine "\nSomebody says, \"#{args}\""
                    player.showPrompt()

exports.Player = Player
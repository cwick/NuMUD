class Player
    constructor: (@client, @db) ->
        @room = @db[1]

    move: (direction) ->
        nextRoomId = @room.links[direction]
        if nextRoomId?
            @room = @db[nextRoomId]
            @speak()
        else
            @client.writeLine "You can't go that way"

    speak: () ->
        @client.writeLine "You are in room #{@room.id}"
        @client.writeLine @room.title
        @client.writeLine()
        @client.writeLine "Exits: [#{e for e of @room.links}]"

    showPrompt: () ->
        @client.write("> ")

exports.Player = Player
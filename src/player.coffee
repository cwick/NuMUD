class Player
    constructor: (@client, @db) ->
        @room = @db[1]
        @isDisconnected = false

        @client.on 'end', () =>
            console.log 'end'
            @isDisconnected = true

    move: (direction) ->
        nextRoomId = @room.links[direction]
        if nextRoomId?
            @room = @db[nextRoomId]
            @speak()
        else
            @writeLine "You can't go that way"

    speak: () ->
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

exports.Player = Player
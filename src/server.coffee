telnet = require './telnet'

players = []

class Room
class Player
    constructor: (@client) ->
        @room = rooms[1]

    move: (direction) ->
        nextRoomId = @room.links[direction]
        if nextRoomId?
            @room = rooms[nextRoomId]
            @speak()
        else
            @client.writeLine "You can't go that way"

    speak: () ->
        @client.writeLine "You are in room #{@room.id}"
        @client.writeLine @room.title
        @client.writeLine()
        @client.writeLine "Exits: [#{e for e of @room.links}]"


rooms = {
1: {
    id: 1
    title: "A long dusty hallway"
    links:
        n: 1
        e: 2
},
2: {
    id: 2
    title: "A small bathroom"
    links:
        w: 1
}}

server = telnet.createServer ((client)->
    player = new Player(client)

    players.push player

    player.speak()

    client.on 'command', (cmd)->
        switch cmd
            when "" then client.writeLine "Please enter a command"
            when "hello" then client.writeLine "Why hello there"
            when "n" then player.move("n")
            when "e" then player.move("e")
            when "w" then player.move("w")
            else client.writeLine "You typed #{cmd}"
        client.write("> ")

    client.on 'close', (had_error)->
        console.log "Bye-bye"
        idx = players.indexOf player
        if idx != -1
            players.splice idx, 1
)

server.listen 8000


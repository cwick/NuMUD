telnet = require './telnet'
Player = require('./player').Player

players = []

class Room

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
    player = new Player(client, rooms)

    players.push player

    player.speak()
    player.showPrompt()

    client.on 'command', (cmd)->
        switch cmd
            when "" then # Do nothing
            when "n" then player.move("n")
            when "e" then player.move("e")
            when "w" then player.move("w")
            when "s" then player.move("s")
            when "quit"
                client.end("goodbye.")
                return
            else client.writeLine "Huh?"
        player.showPrompt()

    client.on 'close', ()->
        idx = players.indexOf player
        if idx != -1
            players.splice idx, 1
)

server.listen 8000


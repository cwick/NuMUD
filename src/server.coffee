telnet = require './telnet'
Player = require('./player').Player
command = require('./cmd')
rooms = require('./rooms')
players = []

server = telnet.createServer ((client)->
    player = new Player(client, rooms)

    player.look()
    player.showPrompt()
    players.push player

    context = {
        player: player
        playerList: players
    }

    client.on 'command', (cmd)->
        command.doString(cmd, context)

        player.showPrompt()

    client.on 'close', ()->
        idx = players.indexOf player
        if idx != -1
            players.splice idx, 1
)

port = 8000
server.listen port


console.log "NuMUD server started on port #{port}"
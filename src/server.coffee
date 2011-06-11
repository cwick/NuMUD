telnet = require './telnet'
Player = require('./player').Player
Command = require('./cmd')
World = require('./world')

server = telnet.createServer ((client)->
    player = new Player(client)
    World.addEntity(player, 1)

    player.look()
    player.showPrompt()

    client.on 'command', (cmd)->
        Command.doString(cmd, player)

        player.showPrompt()

    client.on 'close', () -> World.removeEntity player
)

port = 8000
server.listen port


console.log "NuMUD server started on port #{port}"

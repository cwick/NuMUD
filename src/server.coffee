telnet = require './telnet'
Player = require('./player').Player
command = require('./cmd')
rooms = require('./rooms')
World = require('./world')

world = new World(rooms)

server = telnet.createServer ((client)->
    player = new Player(client)
    world.addPlayer(player)

    player.look()
    player.showPrompt()

    context = {
        player: player
        world: world
    }

    client.on 'command', (cmd)->
        command.doString(cmd, context)

        player.showPrompt()

    client.on 'close', () -> world.removePlayer player
)

port = 8000
server.listen port


console.log "NuMUD server started on port #{port}"

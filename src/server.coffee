Net = require 'net'
#World = require './world'
Entity = require './entity'


# This will eventually be data-driven.
# For now we just do it programatically
createPlayer = () ->
    CommandAspect = require './aspects/command'
    TelnetAspect = require './aspects/telnet'

    player = new Entity()
    for aspect in [CommandAspect, TelnetAspect]
        do (aspect) -> player.installAspect(new aspect())

    return player

server = Net.createServer ((socket)->
    player = createPlayer()
    player.aspect("telnet").setSocket(socket)

    # World.addEntity(player, 1)

    # player.look()
    # player.showPrompt()

    # client.on 'command', (cmd)->
    #     Command.doString(cmd, player)

    #     player.showPrompt()

    # client.on 'close', () -> World.removeEntity player
)

port = 8000
server.listen port


console.log "NuMUD server started on port #{port}"

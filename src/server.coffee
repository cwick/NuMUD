Net = require 'net'
#World = require './world'
Entity = require './entity'


# This will eventually be data-driven.
# For now we just do it programatically, but you can easily see
# how this information could be read from a template file.
createPlayer = () ->
    command = require './aspects/command'
    telnet = require './aspects/telnet'
    log = require './aspects/textLog'

    player = new Entity()
    for aspect in [log, command, telnet]
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

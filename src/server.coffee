Net = require 'net'
Entity = require './entity'
Template = require './template'

# This is a complete hack. Commands still need a bit more design.
registerCommands = (player) ->
    cmd = player.aspect("command")

    cmd.register "quit", null, (entity) ->
        entity.sendMessage("netWriteLine", "goodbye.")
        entity.sendMessage("netDisconnect")

    cmd.register "look", ["l"], (entity) ->
        room = entity.getProperty("placement", "parent")

        entity.sendMessage("netWriteLine", "You are in room #{room.guid}")



createPlayer = () ->
    playerTemplate = Template.load "player"
    player =  playerTemplate.instantiate()
    registerCommands(player)

    return player


# Proof of concept showing how properties can cascade down the prototype chain
createMedBot = () ->
    bot = new Entity()
    bot2 = new Entity()

    HealthAspect = require './aspects/health'
    HealthProperties = ->
    HealthProperties.prototype = HealthAspect.prototype.properties

    MedbotHealthProperties = ->
    MedbotHealthProperties.prototype = new HealthProperties()
    MedbotHealthProperties.prototype.max = 100
    MedbotHealthProperties.prototype.current = 100

    MedbotHealthAspect = ->
        @properties = new MedbotHealthProperties()
        return

    MedbotHealthAspect.prototype = new HealthAspect()
    #MedbotHealthAspect.prototype.properties = new MedbotHealthProperties()

    bot.installAspect(new HealthAspect())
    bot2.installAspect(new HealthAspect())

    botHealth = bot.aspect("health").properties
    bot2Health = bot2.aspect("health").properties

    console.log botHealth.current, bot2Health.current
    console.log "bot takes damage"
    botHealth.current -= 20
    console.log botHealth, bot2Health, botHealth.current, bot2Health.current

server = Net.createServer ((socket)->
    player = createPlayer()
    player.sendMessage("netConnected", socket)


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

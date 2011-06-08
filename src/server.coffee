telnet = require './telnet'
Player = require('./player').Player
command = require('./cmd')

players = []

genmove = (dir) ->
    (context) ->
        context.player.move dir

command.register "north", ["n"], genmove('n')
command.register "east", ["e"], genmove('e')
command.register "south", ["s"], genmove('s')
command.register "west", ["w"], genmove('w')
command.register "quit", null, (context) -> context.player.disconnect "goodbye."
command.register "say", ["^'"], (context, args) ->
    if args.length == 0
        context.player.writeLine "What would you like to say?"
    else
        context.player.writeLine "You say, \"#{args}\" "

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

    player.speak()
    player.showPrompt()
    players.push player

    context = { player: player }

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
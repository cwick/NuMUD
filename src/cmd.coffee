commands = {}

defaultCommand = {
    callback:
        (context) ->
            context.player.writeLine "Huh?"
}

findCommand = (str) ->
    commands[str]

findAlias = (str) ->
    for own k,cmd of commands when str in cmd.aliases
        return cmd

    return null


exports.register = (name, aliases, callback) ->
    commands[name] = {
        name: name
        aliases: aliases
        callback: callback
    }

exports.doString = (str, context) ->
    (findCommand(str) or
     findAlias(str)   or
     defaultCommand).callback(context)

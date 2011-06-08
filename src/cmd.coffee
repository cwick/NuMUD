commands = {}
prefixes = []

PREFIX_SPECIFIER = "^"

# Command chosen when we don't understand what the player typed
defaultCommand = {
    callback:
        (context) ->
            context.player.writeLine "Huh?"
}

# A do-nothing command
emptyCommand = {
    callback: ->
}

# Try to find 'str' in the list of known commands.
# If that fails, find a command which has 'str' as one of its aliases
# If nothing can be found, return undefined
findCommandOrAlias = (str) ->
    findCommand(str) or findAlias(str)

# Try to find 'str' in the list of known commands
# Return the command corresponding to 'str' or undefined
findCommand = (str) ->
    if str == "" then emptyCommand else commands[str]

# Try to find 'str' in the list of known command aliases
# Return the command corresponding to 'str' or undefined
findAlias = (str) ->
    for own k,cmd of commands when str in cmd.aliases
        return cmd

    return null


parseString = (str) =>
    if str == ""
        str

    firstSpace = str.indexOf(" ")

    # If the command uses a prefix shortcut, break it off so the
    # whole string can be parsed in the usual way
    for prefix in prefixes when \
        str.indexOf(prefix) == 0 and \
        prefix.length != firstSpace
            str = "#{prefix} #{str.slice prefix.length}"
            firstSpace = prefix.length
            break

    cmd = str
    args = "" # TODO: make this a list

    if firstSpace != -1
        cmd = str.substring 0, firstSpace
        args = str.slice firstSpace+1

    [cmd, args]

exports.register = (name, aliases, callback) ->
    cmd = {
        name: name
        aliases: aliases
        callback: callback
    }
    commands[name] = cmd

    for alias, i in (aliases or []) \
        when alias?.length > 0 and \
        alias[0] == PREFIX_SPECIFIER
            alias = alias.slice 1
            aliases[i] = alias
            prefixes.push alias

exports.doString = (str, context) ->
    [cmd, args] = parseString str

    (findCommandOrAlias(cmd) or defaultCommand).callback(context, args)
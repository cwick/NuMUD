Aspect = require './aspect'

PREFIX_SPECIFIER = "^"

# Command chosen when we don't understand what the player typed
defaultCommand = {
    callback:
        (entity) ->
            if entity.has "telnet"
                entity.aspect("telnet").writeLine "Huh?"
}

# A do-nothing command
emptyCommand = {
    callback: ->
}

class CommandAspect extends Aspect
    name: "command"
    description: "Enables the entity to respond to commands"

    _onAspectInstalled: (aspect) ->
        if aspect.like "text"
            aspect.on "textInput", (str) => @doString str

    _commands: {}
    _prefixes: []

    # Try to find 'str' in the list of known commands.
    #
    # If that fails, find a command which has 'str' as one of its aliases
    # If nothing can be found, return undefined
    _findCommandOrAlias: (str) ->
        @_findCommand(str) or @_findAlias(str)

    # Try to find 'str' in the list of known commands
    #
    # Return the command corresponding to 'str' or undefined
    _findCommand: (str) ->
        if str == "" then emptyCommand else @_commands[str]

    # Try to find 'str' in the list of known command aliases
    #
    # Return the command corresponding to 'str' or undefined
    _findAlias: (str) ->
        for own k,cmd of @_commands when str in cmd.aliases
            return cmd

        return null

    _parseString: (str) ->
        if str == ""
            return str

        firstSpace = str.indexOf(" ")

        # If the command uses a prefix shortcut, break it off so the
        # whole string can be parsed in the usual way
        for prefix in @_prefixes when \
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


    register: (name, aliases, callback) ->
        cmd = {
            name: name
            aliases: aliases
            callback: callback
        }
        @_commands[name] = cmd

        for alias, i in (aliases or []) \
            when alias?.length > 0 and \
            alias[0] == PREFIX_SPECIFIER
                alias = alias.slice 1
                aliases[i] = alias
                prefixes.push alias

    doString: (str) ->
        [cmd, args] = @_parseString str

        (@_findCommandOrAlias(cmd) or defaultCommand).callback(@entity, args)


module.exports = CommandAspect

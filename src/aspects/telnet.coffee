Net = require 'net'
Aspect = require './aspect'

class TelnetAspect extends Aspect
    name: "telnet"
    description: "Enables the entity to send/receive text data over the telnet protocol"


    setSocket: (@_socket) ->
        @isDisconnected = false
        @_buffer = ""
        @_socket.on 'data', (data)=>
            idx = data.indexOf("\r\n")
            if idx != -1
                # Found end of line, run the command
                @_buffer += data.substring 0, idx
                @emit 'userInput', @_buffer
                @_buffer = ""
            else
                # No end of line yet, keep buffering it up
                @_buffer += data

        # @_socket.on 'close', (had_error)=>
        #     @emit 'close', had_error

        @_socket.on 'end', ()=>
            @isDisconnected = true

        @_socket.setEncoding 'utf8'

    write: (str) ->
        if not @isDisconnected
            @_socket.write str

    writeLine: (str) ->
        str = "#{if str? then str else ''}\r\n"
        @write str

module.exports = TelnetAspect

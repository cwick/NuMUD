Net = require 'net'
TextInterfaceAspect = require './text'

class TelnetAspect extends TextInterfaceAspect
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
                @entity.sendMessage 'textInput', @_buffer
                @_buffer = ""
            else
                # No end of line yet, keep buffering it up
                @_buffer += data

        @_socket.on 'end', ()=>
            @isDisconnected = true

        @_socket.on 'close', ->
            @isDisconnected = true

        @_socket.setEncoding 'utf8'

    write: (str) ->
        if not @isDisconnected
            @_socket.write str
            @entity.sendMessage 'textOutput', str

    writeLine: (str) ->
        str = "#{if str? then str else ''}\r\n"
        @write str

    onNetConnected: (socket) -> @setSocket socket
    onNetWrite: (str) -> @write str
    onNetWriteLine: (str) -> @writeLine str
    onNetDisconnect: ->
        @isDisconnected = true
        @_socket.end()

module.exports = TelnetAspect

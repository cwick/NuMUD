net = require 'net'
events = require 'events'

telnet = exports



class Client extends events.EventEmitter
    constructor: (@_socket) ->
        @_buffer = ""
        @_socket.on 'data', (data)=>
            idx = data.indexOf("\r\n")
            if idx != -1
                # Found end of line, run the command
                @_buffer += data.substring 0, idx
                @emit 'command', @_buffer
                @_buffer = ""
            else
                # No end of line yet, keep buffering it up
                @_buffer += data

        @_socket.on 'close', (had_error)=>
            @emit 'close', had_error

        @_socket.on 'end', ()=>
            @emit 'end'

    writeLine: (str) -> @_socket.write "#{if str? then str else ''}\r\n"
    write: (str) -> @_socket.write str
    end: (data) ->
        @writeLine data
        @_socket.end()

telnet.createServer = (callback) ->
    net.createServer (socket) ->
        socket.setEncoding 'utf8'
        callback new Client(socket)

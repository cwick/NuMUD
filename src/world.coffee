_=require('../underscore')

class Room
    constructor: (@world, definition) ->
        _(this).extend definition

        @entities = []

    addEntity: (entity) ->
        @entities.push entity
        entity.room = this

    removeEntity: (entity) ->
        idx = @entities.indexOf entity
        if idx != -1
            @entities.splice idx, 1
            entity.room = null

    followLink: (direction) ->
        nextRoomId = @links[direction]
        if not _.isUndefined nextRoomId then @world.roomFromId(nextRoomId)

class World
    constructor: (roomDefinitions) ->
        @rooms = {}

        # Load up room objects from their definitions
        for own id, room of roomDefinitions
            do (room) => @rooms[id] = new Room(this, room)

        @players = []

    playersInRoom: (roomOrId) ->
        result = @roomFromId(roomOrId)?.entities
        if not result
            result = []
        return result

    roomFromId: (roomId) ->
        if roomId instanceof Object then roomId else @rooms[roomId]

    addPlayer: (player) ->
        if not _(@players).include player
            @players.push player
            @roomFromId(1).addEntity(player)

    removePlayer: (player) ->
        idx = @players.indexOf player
        if idx != -1
            @players.splice idx, 1
            player.room = null


    moveEntity: (entity, roomOrId) ->
        newRoom = @roomFromId(roomOrId)
        oldRoom = entity.room

        if newRoom and (newRoom isnt oldRoom)
            if oldRoom
                oldRoom.removeEntity(entity)

            newRoom.addEntity(entity)


module.exports = World


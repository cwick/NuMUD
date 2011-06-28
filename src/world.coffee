# _ = require('../lib/underscore')
# entityDefs = require('./entities')
# roomDefs = require('./rooms')
# {Entity} = require('./entity')

# class Room
#     constructor: (@world, definition) ->
#         _(this).extend definition

#         if _.isUndefined @entities
#             @entities = []

#         # Load up entities from the entity database
#         @entities = _.compact(
#             (if entityDefs[id] then new Entity(entityDefs[id]) else null ) for id in @entities)

#     addEntity: (entity) ->
#         if not _(@entities).include entity
#             @entities.push entity
#             entity.room = this

#     removeEntity: (entity) ->
#         idx = @entities.indexOf entity
#         if idx != -1
#             @entities.splice idx, 1
#             entity.room = null

#     followLink: (direction) ->
#         nextRoomId = @links[direction]
#         if not _.isUndefined nextRoomId then @world.roomFromId(nextRoomId)

# class World
#     constructor: (roomDefinitions) ->
#         # Collection of all rooms
#         @rooms = {}
#         # Collection of all entity instances
#         @entities = {}

#         # Load up room objects from their definitions
#         for own id, room of roomDefinitions
#             do (id, room) => @rooms[id] = new Room(this, room)

#     roomFromId: (roomId) ->
#         if roomId instanceof Object then roomId else @rooms[roomId]

#     addEntity: (entity, roomOrId) ->
#         if not @entities[entity.id]
#             @entities[entity.id] = entity
#             @roomFromId(roomOrId).addEntity(entity)

#     removeEntity: (entity) ->
#         delete @entities[entity.id]
#         if entity.room
#             entity.room.removeEntity(entity)


#     moveEntity: (entity, roomOrId) ->
#         newRoom = @roomFromId(roomOrId)
#         oldRoom = entity.room

#         if newRoom and (newRoom isnt oldRoom)
#             eventArgs =
#                 oldRoom: oldRoom
#                 newRoom: newRoom

#             if oldRoom
#                 oldRoom.removeEntity(entity)
#                 @emit "leaveRoom", entity, eventArgs, (e)->e.room is oldRoom

#             newRoom.addEntity(entity)
#             @emit "enterRoom", entity, eventArgs, (e)->e.room is newRoom


#     emit: (event, sender, args, filter) ->
#         if not filter
#             filter = -> true

#         for id, entity of @entities when filter(entity)
#                 do (entity) -> entity.handleEvent(event, sender, args)

entities = {}
getEntityById = (id) ->
    return entities[id]

module.exports = World


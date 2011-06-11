rooms = [ \
{
    id: 1
    title: "A long dusty hallway"
    links:
        n: 3
        e: 2
    entities: [1]
},
{
    id: 2
    title: "A small bathroom"
    links:
        w: 1
},
{
    id: 3
    title: "An elegant dining room"
    links:
        s: 1
}]

roomDatabase = {}
for room in rooms
    roomDatabase[room.id] = room

module.exports = roomDatabase

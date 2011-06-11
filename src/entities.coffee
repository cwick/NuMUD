entities = [ \
{
    id: 1
    name: "Kobold warrior"
}]


entityDatabase = {}
for entity in entities
    entityDatabase[entity.id] = entity

module.exports = entityDatabase


Aspect = require './aspect'

class PlacementAspect extends Aspect
    name: "placement"
    description:"Allows an entity to be positioned in the world"

    properties: {
        parent: {type: "guid"}
    }

module.exports = PlacementAspect

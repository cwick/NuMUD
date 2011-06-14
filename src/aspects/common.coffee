Aspect = require './aspect'

class CommonAspect extends Aspect
    name: "common"
    description:"Contains common entity properties"

    properties: {
        name: {type: "string"}
    }

module.exports = CommonAspect

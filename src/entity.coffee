_ = require('../lib/underscore')

lastId = 0
class Entity
    constructor: (definition) ->
        _(this).extend definition
        lastId += 1
        @id=lastId

    # TODO: not really how it's going to work, just here to satisfy duck typing
    # till I find a better solution
    write: ->
    writeLine: ->
    showPrompt: ->

exports.Entity = Entity

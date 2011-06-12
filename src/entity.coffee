

class Entity
    constructor: () ->
        @_aspects = {}


    has: (aspectName) ->
        @_aspects[aspectName]?

    aspect: (aspectName) ->
        @_aspects[aspectName]

    installAspect: (aspect) ->
        if not @has aspect
            aspect.entity = this
            @_aspects[aspect.name] = aspect

        newAspect = aspect
        for name, aspect of @_aspects
            do (aspect) ->
                aspect._onAspectInstalled(newAspect)

module.exports = Entity

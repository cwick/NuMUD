

class Entity
    constructor: () ->
        @_aspects = []

    # Return true if this entity has an aspect with the given name,
    # or has an aspect derived from the given name
    has: (aspectName) ->
        for aspect in @_aspects
            if aspect.like aspectName
                return true
        return false

    # Return an aspect with the given name, or one derived from the given name.
    # Return null if no matching aspect could be found.
    aspect: (aspectName) ->
        for aspect in @_aspects
            if aspect.like aspectName then return aspect

        return null

    # Installs an aspect into the entity. Raise Error if the entity already
    # has an aspect with the same name as the one being installed.
    installAspect: (aspect) ->
        if @has aspect.baseName
            throw new Error("Entity already has aspect '#{aspect.baseName}'")

        aspect.entity = this
        @_aspects.push aspect


    # Send a message to the entity. The message will be handled by all
    # aspects currently installed in the entity which are capable of responding to
    # the given message.
    sendMessage: (msg, data) ->
        attr = "on#{msg.charAt(0).toUpperCase()}#{msg.slice(1)}"

        for aspect in @_aspects
            handler = aspect[attr]
            if handler
                handler.call aspect,data

    # Get the value of a property from an aspect
    getProperty: (aspectName, key) ->
        return @aspect(aspectName)?.properties[key]

module.exports = Entity

fs = require 'fs'
Entity = require './entity'


createAspect = (name, properties) ->
    aspectConstructor = require "./aspects/#{name}"
    aspectInstance = new aspectConstructor()

    AspectProperties = ->
    AspectProperties.prototype = properties

    aspectInstance.properties = new AspectProperties()

    return aspectInstance

load = (name) ->
    buffer = fs.readFileSync "data/templates/#{name}.json", 'utf8'
    template = JSON.parse buffer
    entity = new Entity()

    for aspectName, properties of template.aspects
        entity.installAspect (createAspect aspectName, properties)

    return entity

exports.load = load

fs = require 'fs'
Entity = require './entity'


namedTemplates = {}
instanceTemplates = {}

# Quick n' dirty template loading. Just load everything into memory.
loaded = false
loadFromDisk = ->
    path = "data/templates/"
    files = fs.readdirSync path
    for file in files
        buffer = fs.readFileSync (path + file)
        templateList = JSON.parse buffer
        for template in templateList
            templateWrapper = new Template(template)
            if template.name
                namedTemplates[template.name] = templateWrapper
            else if template.sid?
                instanceTemplates[template.sid] = templateWrapper
    loaded = true

load = (name)->
    if not loaded
        loadFromDisk()

    return namedTemplates[name]

class Template
    constructor: (@_template) ->

    _createAspect: (name, properties) ->
        aspectConstructor = require "./aspects/#{name}"
        aspectInstance = new aspectConstructor()

        AspectProperties = ->
        AspectProperties.prototype = properties

        aspectInstance.properties = new AspectProperties()

        return aspectInstance

    instantiate: ->
        entity = new Entity()
        entity.sid = @_template.sid

        for aspectName, properties of @_template.aspects
            entity.installAspect (@_createAspect aspectName, properties)

        return entity

exports.load = load

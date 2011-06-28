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
            else if template.id?
                instanceTemplates[template.id] = templateWrapper
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

        for key of properties
            propertyDeclaration = aspectConstructor.prototype.properties?[key]
            if not propertyDeclaration?
                throw new Error("Unknown property '#{key}'")

            if not propertyDeclaration.type?
                throw new Error("Missing 'type' specifier for property '#{key}'")

            if propertyDeclaration.type == "guid"
                Object.defineProperty properties, key, {get: -> "hello"}

        aspectInstance.properties = new AspectProperties()

        return aspectInstance

    instantiate: ->
        entity = new Entity()
        entity.id = @_template.id

        for aspectName, properties of @_template.aspects
            entity.installAspect (@_createAspect aspectName, properties)

        return entity

exports.load = load

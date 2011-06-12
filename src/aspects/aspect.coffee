
EventEmitter = (require 'events').EventEmitter

class Aspect extends EventEmitter
    _onAspectInstalled: ->


    # Returns true if this aspect is derived from the given aspect name
    like: (name) ->
        _like = (name, obj) ->
            if not obj
                false
            else if obj.name == name
                true
            else
                _like name, Object.getPrototypeOf obj

        _like name, this


module.exports = Aspect

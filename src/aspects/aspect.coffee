
class Aspect
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

Object.defineProperty Aspect.prototype, "baseName", {
    get: ->
        proto = Object.getPrototypeOf this
        baseName = null

        while proto.name
            baseName = proto.name
            proto = Object.getPrototypeOf proto

        return baseName
}
module.exports = Aspect

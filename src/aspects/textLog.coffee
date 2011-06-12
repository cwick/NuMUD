TextInterfaceAspect = require './text'

class TextLogAspect extends TextInterfaceAspect
    name: "textLog"
    description: "Enables logging of text to standard out"

    _onAspectInstalled: (aspect) ->
        logText = (prefix) -> (text) -> console.log "#{prefix}: #{text}"
        if aspect.like "text"
            aspect.on "textInput", logText "Input"
            aspect.on "textOutput", logText "Output"

module.exports = TextLogAspect

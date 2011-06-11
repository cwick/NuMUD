class HealSpell
    cast: (caster) ->
        healAmount = 40
        spellCost = 13
        caster.hp += healAmount
        caster.mana -= spellCost

        return { amount: healAmount }


class HealSpellView
    something: (player) ->
        player.writeLine "#{caster.name} heals for #{something} points"


class SpellView
    constructor: (@viewer) ->

class SpeakSpellView extends SpellView
    render: (caster, data) ->
        if @viewer == caster
            @viewer.writeLine "You say, \"#{data.message}\""
        else
            @viewer.writeLine()
            @viewer.writeLine "Somebody says, \"#{data.message}\""
            @viewer.showPrompt()



class Spell
    cast: (world, caster, args...) ->
        [data, entities] = @apply world, caster, args
        for entity in entities
            new @view(entity).render caster, data

    apply: (world, caster, args...) -> [{}, []]
    view: SpellView

class SpeakSpell extends Spell
    apply: (world, caster, message) ->
        return [{ message: message }, caster.room.entities]

    view: SpeakSpellView



exports.speak = new SpeakSpell()

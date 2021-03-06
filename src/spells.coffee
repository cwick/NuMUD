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



class Spell
    cast: (caster, args...) ->
        [data, entities] = @apply caster, args
        for entity in entities
            new @view(entity).render caster, data

    apply: (caster, args...) -> [{}, []]
    view: SpellView

class SpeakSpell extends Spell
    apply: (caster, message) ->
        return [{ message: message }, caster.room.entities]

    view: SpeakSpellView



exports.speak = new SpeakSpell()

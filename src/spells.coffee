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
    constructor: (@player) ->

class SpeakSpellView extends SpellView
    render: (caster, data) ->
        if @player == caster
            @player.writeLine "You say, \"#{data.message}\""
        else
            @player.writeLine()
            @player.writeLine "Somebody says, \"#{data.message}\""
            @player.showPrompt()



class Spell
    cast: (context, caster, args...) ->
        [data, players] = @apply context, caster, args
        for player in players
            new @view(player).render caster, data

    apply: (context, caster, args...) -> [{}, []]
    view: SpellView

class SpeakSpell extends Spell
    apply: (context, caster, message) ->
        return [{ message: message }, context.playerList]

    view: SpeakSpellView



exports.speak = new SpeakSpell()

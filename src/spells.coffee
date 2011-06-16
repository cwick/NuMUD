class HealSpell
    cast: (caster) ->
        healAmount = 40
        spellCost = 13
        caster.hp += healAmount
        caster.mana -= spellCost

        return { amount: healAmount }

class SpeakSpell
    cast: (caster, message) ->
        return { message: message }

class HealSpellView
    something: (player) ->
        player.writeLine "#{caster.name} heals for #{something} points"

class SpeakSpellView
    render: (player, caster, data) ->
        if player == caster
            player.writeLine "You say, \"#{data.message}\""
        else
            player.writeLine()
            player.writeLine "Somebody says, \"#{data.message}\""
            player.showPrompt()



exports.SpeakSpell = SpeakSpell
exports.SpeakSpellView = SpeakSpellView

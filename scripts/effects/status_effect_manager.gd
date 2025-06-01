extends Node

var effects: Array[StatusEffect] = []

func add_effect(effect: StatusEffect, target):
	effect.apply(target)
	effects.append(effect)

func _process(delta):
	for i in range(effects.size() - 1, -1, -1):
		var effect = effects[i]
		effect.update(get_parent(), delta)
		if effect.is_finished():
			effect.remove(get_parent())
			effects.remove_at(i)

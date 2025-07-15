extends Component
class_name EffectComponent

@export var entity: CharacterBody2D

var effect_registry := {
	"stun": preload("res://component/effect/stun_effect.gd"),
	"slow": preload("res://component/effect/slow_effect.gd"),
	"root": preload("res://component/effect/root_effect.gd"),
	"paralyze": preload("res://component/effect/paralyze_effect.gd"),
	"float": preload("res://component/effect/float_effect.gd"),
	"confusion": preload("res://component/effect/confusion_effect.gd"),
	"airborne": preload("res://component/effect/airborne_effect.gd"),
}

func request_effect(effect_name: String, duration: float, level: float):
	if is_multiplayer_authority():
		var pid = entity.get_multiplayer_authority()
		EffectManager.rpc_id(1, "request_add_effect", pid, effect_name, duration, level)

func apply_effect(effect_name: String, duration: float, level: float, effect_id: int):
	if not effect_registry.has(effect_name):
		push_error("Effect not found in registry: " + effect_name)
		return

	var effect = effect_registry[effect_name].new(duration, level)
	effect.name = "effect_%d" % effect_id
	effect.effect_id = effect_id
	effect.component = self
	add_child(effect)
	effect.apply()

func remove_effect(effect_id: int):
	var effect = get_node_or_null("effect_%d" % effect_id)
	if effect:
		effect.remove()
		effect.queue_free()

func update_component(delta):
	for effect in get_children():
		effect.update(delta)
		if effect.is_finished():
			if is_multiplayer_authority():
				var pid = entity.get_multiplayer_authority()
				EffectManager.rpc_id(1, "request_remove_effect", pid, effect.effect_id)

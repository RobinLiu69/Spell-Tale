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

func applying_effect(effects: Dictionary):
	for key in effects.keys():
		if effect_registry.has(key):
			var effect_info = effects[key]
			request_effect(key, effect_info[0], effect_info[1])
		else:
			printerr("No effect named:", effects[key])


func request_effect(effect_name: String, duration: float, level: float):
	var pid = entity.get_multiplayer_authority()
	
	if multiplayer.is_server():
		if has_node("/root/EffectManager"):
			EffectManager.apply_effect_on_all.rpc(pid, effect_name, duration, level)
	else:
		if has_node("/root/EffectManager"):
			EffectManager.rpc_id(1, "request_add_effect", pid, effect_name, duration, level)

func apply_effect(effect_name: String, duration: float, level: float, effect_id: int):
	var effect_scene = effect_registry[effect_name]
	var effect = effect_scene.new(duration, level)
	effect.effect_id = effect_id
	effect.name = "effect_" + str(effect_id)
	effect.component = self
	add_child(effect)
	effect.apply(entity)


func update_component(delta):
	for effect in get_children():
		effect.update(delta)
		if effect.is_finished():
			if is_multiplayer_authority():
				var pid = entity.get_multiplayer_authority()
				EffectManager.rpc("remove_effect_on_all", pid, effect.effect_id)

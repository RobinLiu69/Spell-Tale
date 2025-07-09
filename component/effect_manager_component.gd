extends Component
class_name EffectManagerComponent

@export var entity: CharacterBody2D

var effect_registry := {
	"stun_effect": preload("res://component/effect/stun_effect.gd"),
	"slow_effect": preload("res://component/effect/slow_effect.gd"),
	"root_effect": preload("res://component/effect/root_effect.gd"),
	"paralyze_effect": preload("res://component/effect/paralyze_effect.gd"),
	"float_effect": preload("res://component/effect/float_effect.gd"),
	"confusion_effect": preload("res://component/effect/confusion_effect.gd"),
	"airborne_effect": preload("res://component/effect/airborne_effect.gd")
}

func request_add_effect(effect_name: String, duration: float, level: int):
	if is_multiplayer_authority():
		var pid = entity.get_multiplayer_authority()
		rpc_id(1, "server_receive_effect_request", pid, effect_name, duration, level)

@rpc("authority")
func server_receive_effect_request(pid: int, effect_name: String, duration: float, level: int):
	if not multiplayer.is_server():
		return
	rpc("apply_effect_on_all", pid, effect_name, duration, level)

@rpc("any_peer", "call_local")
func apply_effect_on_all(pid: int, effect_name: String, duration: float, level: int):
	var player = PlayerManager.get_player(pid)
	if not player:
		push_warning("Player not found: " + str(pid))
		return

	var effect_manager = player.effect_manager_component
	if not effect_registry.has(effect_name):
		push_error("Effect not found: " + effect_name)
		return

	var effect_scene = effect_registry[effect_name]
	var effect = effect_scene.new(duration, level)

	effect.name = effect_name + "_" + str(Time.get_ticks_usec())  # 唯一名稱
	effect.component = effect_manager

	effect_manager.add_child(effect)
	effect.apply(effect_manager.entity)

func update_component(delta):
	for effect in get_children():
		effect.update(delta)
		if effect.is_finished():
			if is_multiplayer_authority():
				var pid = entity.get_multiplayer_authority()
				rpc_id(1, "server_remove_effect_request", pid, effect.name)

@rpc("authority")
func server_remove_effect_request(pid: int, effect_node_name: String):
	rpc("remove_effect_on_all", pid, effect_node_name)

@rpc("any_peer", "call_local")
func remove_effect_on_all(pid: int, effect_node_name: String):
	var player = PlayerManager.get_player(pid)
	if not player:
		return

	var effect = player.effect_manager_component.get_node_or_null(effect_node_name)
	if effect:
		effect.remove(player.effect_manager_component.entity)
		effect.queue_free()

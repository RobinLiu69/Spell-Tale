extends Node

var next_effect_id: int = 1
var effect_map := {}

func get_new_effect_id() -> int:
	var id = next_effect_id
	next_effect_id += 1
	return id


func _ready():
	if not multiplayer.is_server():
		set_process(false)

@rpc("authority")
func request_add_effect(pid: int, effect_name: String, duration: float, level: float):
	var effect_id = get_new_effect_id()
	rpc("apply_effect_on_all", pid, effect_name, duration, level, effect_id)
	apply_effect_on_all.rpc(pid, effect_name, duration, level, effect_id)

@rpc("any_peer", "call_local")
func apply_effect_on_all(pid: int, effect_name: String, duration: float, level: float, effect_id: int):
	var player = PlayerManager.get_player(pid)
	if not player:
		return
	
	var effect_component = player.get_node_or_null("EffectComponent")
	if not effect_component:
		return
	
	effect_component.apply_effect(effect_name, duration, level, effect_id)

@rpc("authority")
func request_remove_effect(pid: int, effect_name: String):
	if not multiplayer.is_server():
		return
	remove_effect_on_all.rpc(pid, effect_name)

@rpc("any_peer", "call_local")
func remove_effect_on_all(pid: int, effect_id: int):
	var player = PlayerManager.get_player(pid)
	if not player:
		return
	
	var effect_component = player.get_node_or_null("EffectComponent")
	if not effect_component:
		return
	
	var effect = effect_component.get_node_or_null("effect_" + str(effect_id))
	if effect:
		effect.remove()
		effect.queue_free()

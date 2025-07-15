extends Node

var next_effect_id := 1

func _ready():
	if not multiplayer.is_server():
		set_process(false)

func get_new_effect_id() -> int:
	var id = next_effect_id
	next_effect_id += 1
	return id

@rpc("any_peer")
func request_add_effect(pid: int, effect_name: String, duration: float, level: float):
	if !multiplayer.is_server():
		return

	var effect_id = get_new_effect_id()
	apply_effect_on_all.rpc(pid, effect_name, duration, level, effect_id)

@rpc("any_peer", "call_local")
func apply_effect_on_all(pid: int, effect_name: String, duration: float, level: float, effect_id: int):
	var player = PlayerManager.get_player(pid)
	if not player:
		push_warning("apply_effect_on_all: Player not found for pid: " + str(pid))
		return

	var component := player.get_node_or_null("EffectComponent")
	if component:
		component.apply_effect(effect_name, duration, level, effect_id)

@rpc("any_peer", "call_local")
func request_remove_effect(pid: int, effect_id: int):
	if !multiplayer.is_server():
		return

	remove_effect_on_all.rpc(pid, effect_id)

@rpc("any_peer", "call_local")
func remove_effect_on_all(pid: int, effect_id: int):
	var player = PlayerManager.get_player(pid)
	if not player:
		return

	var component := player.get_node_or_null("EffectComponent")
	if component:
		component.remove_effect(effect_id)

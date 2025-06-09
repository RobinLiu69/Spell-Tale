class_name TotemComponent
extends Node

@export var source: Node2D

func place(totem_name: String, position: Vector2, direction: Vector2):
	_place_rpc.rpc(multiplayer.get_unique_id(), totem_name, position, direction)

@rpc("call_local")
func _place_rpc(caster_pid: int, totem_name: String, position: Vector2, direction: Vector2):
	if not TotemRegistry.TOTEMS.has(totem_name):
		push_error("totem %s not found in registry" % totem_name)
		return
	var totem_info := TotemRegistry.get_totem_info(totem_name)
	var totem: Totem = totem_info.instantiate()
	totem.position = position
	totem.look_at(position + direction)
	totem.source = source
	totem.set_multiplayer_authority(caster_pid)
	source.get_parent().add_child(totem)
	totem.activate()

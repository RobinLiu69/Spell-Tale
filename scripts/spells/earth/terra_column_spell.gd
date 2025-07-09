class_name TerraColumnSpell
extends Spell


var spell_factory: SpellFactoryComponent = null
var ground_pos: Vector2

func cast() -> bool:
	ground_pos = find_ground_below(global_position)
	if ground_pos == Vector2.ZERO:
		request_remove()
		return false
	
	if is_multiplayer_authority():
		_fire()
	
	request_remove()
	return true


func find_ground_below(mouse_pos: Vector2) -> Vector2:
	var space := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.new()
	query.from = mouse_pos
	query.to = mouse_pos + Vector2.DOWN * 1000
	query.collision_mask = 1

	var result := space.intersect_ray(query)

	if result:
		return result.position
	else:
		return Vector2.ZERO


@rpc("any_peer")
func spawn_column(pos: Vector2, spell_id: int, caster_pid: int):
	if spell_factory == null:
		var player = PlayerManager.get_player(caster_pid)
		if player:
			spell_factory = player.get_node("SpellFactoryComponent")
		else:
			printerr("Can't find player whose caster_pid is ", caster_pid)
			return

	spell_factory.spawn_spell("terra_column", pos, caster_pid, spell_id)


func _fire():
	if !is_multiplayer_authority():
		return

	if spell_factory == null:
		var player = PlayerManager.get_player(caster_pid)
		if player:
			spell_factory = player.get_node("SpellFactoryComponent")
		else:
			printerr("Can't find player whose caster_pid is ", caster_pid)
			return
	
	SpellManager.clear_spell_by_name("TerraColumn")

	var new_spell_id = SpellManager.get_new_id()
	rpc("spawn_column", ground_pos, new_spell_id, caster_pid)
	spawn_column(ground_pos, new_spell_id, caster_pid)

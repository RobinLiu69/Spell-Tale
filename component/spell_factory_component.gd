extends Component
class_name SpellFactoryComponent

@export var player: Node
var last_spawned_spell: Spell = null

func spawn_spell(spell_name: String, target_pos: Vector2, caster_pid: int, spell_id: int) -> Spell:
	var spell_info := SpellRegistry.get_spell_info(spell_name)
	var cast_at: String = spell_info.get("cast_at")
	var packed_scene: PackedScene = spell_info.get("packed_scene")
	var spell: Spell = packed_scene.instantiate()

	spell.set_multiplayer_authority(caster_pid)
	spell.name += "-"+str(spell_id)
	spell.caster_pid = caster_pid
	spell.spell_id = spell_id
	spell.source = player
	
	match cast_at:
		"marker":
			var marker = player.get_node("SpellConComponent/Marker2D")
			spell.position = marker.global_position
			spell.rotation = marker.global_rotation
			player.get_tree().current_scene.add_child(spell)
		"player_pos":
			player.add_child(spell)
		"marker_dir+player_pos":
			var marker = player.get_node("SpellConComponent/Marker2D")
			spell.rotation = marker.global_rotation
			player.add_child(spell)
		"target_pos":
			spell.position = target_pos
			player.get_tree().current_scene.add_child(spell)
		_:
			spell.position = player.global_position
			player.get_tree().current_scene.add_child(spell)
	
	
	SpellManager.register_spell(spell_id, spell)
	SpellManager.register_spell_on_clients(spell_id, spell)
	
	
	last_spawned_spell = spell
	return spell

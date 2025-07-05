extends Component
class_name SpellFactoryComponent

@export var player: Node
var last_spawned_spell: Spell = null

func spawn_spell(spell_name: String, target_pos: Vector2, caster_pid: int, spell_id: int) -> void:
	var spell_info := SpellRegistry.get_spell_info(spell_name)
	var cast_at: String = spell_info.get("cast_at")
	var packed_scene: PackedScene = spell_info.get("packed_scene")
	var spell: Spell = packed_scene.instantiate()

	spell.set_multiplayer_authority(caster_pid)
	spell.spell_id = spell_id
	spell.source = player

	match cast_at:
		"marker":
			var marker = player.get_node("SpellConComponent/Marker2D")
			spell.position = marker.global_position
			spell.rotation = marker.global_rotation
		"target_pos":
			spell.position = target_pos
		_:
			spell.position = player.global_position

	spell.cast()
	player.get_tree().current_scene.add_child(spell)
	last_spawned_spell = spell

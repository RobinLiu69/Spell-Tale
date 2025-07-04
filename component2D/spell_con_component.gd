extends Component2D

@export var entity : CharacterBody2D
@onready var marker_2d: Marker2D = $Marker2D

func update_component(delta):
	self.look_at(entity.mouse_pos)
	
func request_cast(spell_name, target_pos):
	var my_id = multiplayer.get_unique_id()
	
	if is_multiplayer_authority():
		server_cast(spell_name, target_pos, my_id)
	else:
		rpc_id(1, "server_cast", spell_name, target_pos, my_id)

@rpc("authority")
func server_cast(spell_name, target_pos, caster_pid):
	var spell_id := SpellManager.get_new_id()
	rpc("spawn_spell", spell_name, target_pos, caster_pid, spell_id)
	spawn_spell(spell_name, target_pos, caster_pid, spell_id)
	print("server spawned")


@rpc("any_peer")
func spawn_spell(spell_name, target_pos, caster_pid, spell_id):
	var spell_info := SpellRegistry.get_spell_info(spell_name)
	var cast_at: String = spell_info.get("cast_at", "marker")


	var spell: Spell = SpellRegistry.instantiate_spell_scene(spell_name)
	if spell == null:
		push_error("Failed to instantiate spell: %s" % spell_name)
		return

	spell.set_multiplayer_authority(caster_pid)
	spell.spell_id = spell_id
	get_tree().current_scene.add_child(spell)

	print("spell spawned:", spell_name, spell_id)

	# 設定位置與旋轉
	if cast_at == "marker":
		spell.position = marker_2d.global_position
		spell.rotation = marker_2d.global_rotation
	elif cast_at == "target_pos":
		spell.position = target_pos

	spell.cast()
	SpellManager.register_spell(spell_id, spell)

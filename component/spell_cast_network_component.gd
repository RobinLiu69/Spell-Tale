extends Component
class_name SpellCastNetworkComponent

@export var player: Node
@export var spell_factory: SpellFactoryComponent
@export var mana_component: ManaComponent


@rpc("any_peer")
func server_cast(spell_name: String, target_pos: Vector2, caster_pid: int):
	if !multiplayer.is_server():
		return
	
	var spell_info = SpellRegistry.get_spell_info(spell_name)
	var mana_cost = spell_info.get("mana_cost", 0)
	
	mana_component.use_mana_multi.rpc_id(caster_pid, mana_cost)
	
	var spell_id = SpellManager.get_new_id()
	rpc("spawn_spell", spell_name, target_pos, caster_pid, spell_id)


@rpc("any_peer", "call_local")
func spawn_spell(spell_name: String, target_pos: Vector2, caster_pid: int, spell_id: int):
	var spell = spell_factory.spawn_spell(spell_name, target_pos, caster_pid, spell_id)

	spell.cast()
  
	if caster_pid != multiplayer.get_unique_id():
		var battle_ui := get_tree().get_root().get_node("Game/UI/Battle_UI")
		if battle_ui:
			battle_ui.update_enemy_skill(-1, spell_name)

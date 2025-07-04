extends Component
class_name SpellCastNetworkComponent

@export var player: Node
@export var spell_factory: SpellFactoryComponent
@export var mana_component: ManaComponent

@rpc("authority")
func server_cast(spell_name: String, target_pos: Vector2, caster_pid: int):
	var spell_info = SpellRegistry.get_spell_info(spell_name)
	var mana_cost = spell_info[1].get("mana_cost", 0)

	if not mana_component or not mana_component.use_mana_multi(mana_cost):
		print("Server: Not enough mana.")
		return

	var spell_id = SpellManager.get_new_id()
	rpc("spawn_spell", spell_name, target_pos, caster_pid, spell_id)
	spell_factory.spawn_spell(spell_name, target_pos, caster_pid, spell_id)
	SpellManager.register_spell(spell_id, spell_factory.last_spawned_spell)

@rpc("any_peer")
func spawn_spell(spell_name: String, target_pos: Vector2, caster_pid: int, spell_id: int):
	spell_factory.spawn_spell(spell_name, target_pos, caster_pid, spell_id)
	SpellManager.register_spell(spell_id, spell_factory.last_spawned_spell)

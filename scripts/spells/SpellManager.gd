extends Node

var next_id: int = 1
var spell_dict: Dictionary = {}

func get_new_id() -> int:
	var id = next_id
	next_id += 1
	return id

func register_spell(spell_id: int, spell: Node):
	spell_dict[spell_id] = spell

@rpc("any_peer", "call_local")
func register_spell_on_clients(spell_id: int, spell: Node):
	SpellManager.register_spell(spell_id, spell)

@rpc("authority")
func request_remove(spell_id: int):
	remove_spell(spell_id)
	rpc("remove_on_client", spell_id)

@rpc("any_peer", "call_local")
func remove_on_client(spell_id: int):
	remove_spell(spell_id)

func remove_spell(spell_id: int):
	if spell_dict.has(spell_id):
		spell_dict[spell_id].queue_free()
		spell_dict.erase(spell_id)
